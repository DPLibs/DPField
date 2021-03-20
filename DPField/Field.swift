import Foundation
import DPLibrary

open class Field<Value>: NSObject, FormFieldProtocol {
    
    // MARK: - Props
    public typealias DidSetValueHanlder = (Value?) -> Void
    public typealias DidSetErrorsHanlder = (FieldValidations) -> Void
    
    private var didSetValueHanlders = Handlers<DidSetValueHanlder?>()
    private var didSetErrorsHanlders = Handlers<DidSetErrorsHanlder?>()
    
    public let validations: FieldValidations

    public var value: Value? {
        didSet {
            self.didSetValueHanlders.execute { [weak self] _, handler in
                handler?(self?.value)
            }
            
            self.didChangeFieldValueHanlders.execute { [weak self] _, handler in
                handler?(self)
            }
        }
    }
    
    public var errors: FieldValidations = [] {
        didSet {
            self.didSetErrorsHanlders.execute { [weak self] _, handler in
                handler?(self?.errors ?? [])
            }
            
            self.didChangeFieldErrorsHanlders.execute { [weak self] _, handler in
                handler?(self)
            }
        }
    }
    
    // MARK: - Init
    public init(validations: FieldValidations, value: Value?) {
        self.validations = validations
        self.value = value
    }
    
    // MARK: - Public methods
    public func didSetValue(_ handler: DidSetValueHanlder?) {
        _ = self.didSetValueHanlders.append(handler)
        
    }

    public func didSetErrors(_ handler: DidSetErrorsHanlder?) {
        _ = self.didSetErrorsHanlders.append(handler)
    }
    
    public func appdendingDidSetValue(_ handler: DidSetValueHanlder?) -> HandlerKey {
        self.didSetValueHanlders.append(handler)
        
    }

    public func appdendingDidSetErrors(_ handler: DidSetErrorsHanlder?) -> HandlerKey {
        self.didSetErrorsHanlders.append(handler)
    }

    // MARK: - FormFieldProtocol
    public var didChangeFieldValueHanlders = Handlers<((FormFieldProtocol?) -> Void)?>()
    public var didChangeFieldErrorsHanlders = Handlers<((FormFieldProtocol?) -> Void)?>()
    
    open var needAppendToDictionary: Bool {
        true
    }
    
    open func getValue() -> Any? {
        self.value
    }
    
    open func getErrors() -> FieldValidations {
        self.errors
    }
    
    open func createErrors(with mode: FieldValidation.Mode) {
        self.errors = self.validations.gotErrors(for: self.value, with: mode)
    }
    
    open func keyForDictionary() -> String? {
        nil
    }
    
    open func valueForDictionary() -> Any? {
        if let dictionary = (self.value as? Codable)?.dictionary, !dictionary.isEmpty {
            return dictionary
        } else {
            return self.value as? Codable
        }
    }
}

public protocol FormFieldProtocol {
    
    var didChangeFieldValueHanlders: Handlers<((FormFieldProtocol?) -> Void)?> { get set }
    var didChangeFieldErrorsHanlders: Handlers<((FormFieldProtocol?) -> Void)?> { get set }
    
    var needAppendToDictionary: Bool { get }
    
    func getValue() -> Any?
    func getErrors() -> FieldValidations

    func createErrors(with mode: FieldValidation.Mode)
    func keyForDictionary() -> String?
    func valueForDictionary() -> Any?
}

open class FormFields: NSObject {
    
    // MARK: - Props
    public typealias DidChangeFieldHanlder = (FormFieldProtocol?) -> Void
    public typealias DidChangeErrorsHanlder = (FormFieldProtocol?) -> Void
    
    private var didChangeFieldValueHanlders = Handlers<DidChangeFieldHanlder?>()
    private var didChangeFieldErrorsHanlders = Handlers<DidChangeErrorsHanlder?>()

    // MARK: - Init
    public override init() {
        super.init()
        
        self.setupHandlers()
    }

    // MARK: - Public methods
    open func createErrors(with mode: FieldValidation.Mode) -> FieldValidations {
        var result: FieldValidations = []
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard let field = child.value as? FormFieldProtocol else { return }

            field.createErrors(with: mode)
            result += field.getErrors()
        })

        return result
    }

    open func createDictionary() -> [String: Any?] {
        var result: [String: Any?] = [:]
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard
                let field = child.value as? FormFieldProtocol,
                field.needAppendToDictionary,
                let value = field.valueForDictionary(),
                let key = child.label
            else { return }

            result[field.keyForDictionary() ?? key] = value
        })

        return result
    }

    open func setupHandlers() {
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard let field = child.value as? FormFieldProtocol else { return }
            
            _ = field.didChangeFieldValueHanlders.append { [weak self] fieldChanged in
                self?.didChangeFieldValueHanlders.execute({ _, handler in
                    handler?(fieldChanged)
                })
            }

            _ = field.didChangeFieldErrorsHanlders.append { [weak self] fieldChanged in
                self?.didChangeFieldErrorsHanlders.execute({ _, handler in
                    handler?(fieldChanged)
                })
            }
        })
    }
    
    public func didChangeField(_ handler: DidChangeFieldHanlder?) {
        _ = self.didChangeFieldValueHanlders.append(handler)
        
    }

    public func didChangeErrors(_ handler: DidChangeErrorsHanlder?) {
        _ = self.didChangeFieldErrorsHanlders.append(handler)
    }
    
    public func appendingDidChangeField(_ handler: DidChangeFieldHanlder?) -> HandlerKey {
        self.didChangeFieldValueHanlders.append(handler)
        
    }

    public func appendingDidChangeErrors(_ handler: DidChangeErrorsHanlder?) -> HandlerKey {
        self.didChangeFieldErrorsHanlders.append(handler)
    }
}
