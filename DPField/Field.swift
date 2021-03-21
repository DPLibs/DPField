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
    
    public func gotErrors(with mode: FieldValidation.Mode) -> FieldValidations {
        self.validations.gotErrors(for: self.value, with: mode)
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




