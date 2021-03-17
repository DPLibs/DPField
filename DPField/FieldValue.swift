import Foundation

public protocol FormField {
    var errors: FieldValidations { get set }
    
    var didSetValueAnyHanlders: HandlerList<((FormField, Any?) -> Void)?> { get set }
    var didSetErrorsAnyHanlders: HandlerList<((FormField, FieldValidations) -> Void)?> { get set }
    
    func getValue() -> Encodable?
    func updateErrors(with mode: FieldValidation.Mode)
}

open class Field<ValueType: Encodable>: NSObject, FormField {
    
    public var didSetValueAnyHanlders = HandlerList<((FormField, Any?) -> Void)?>()
    public var didSetErrorsAnyHanlders = HandlerList<((FormField, FieldValidations) -> Void)?>()
    
    public typealias DidSetValueHanlder = (ValueType?) -> Void
    public typealias DidSetErrorsHanlder = (FieldValidations) -> Void
    
    public var didSetValueHanlders = HandlerList<DidSetValueHanlder?>()
    public var didSetErrorsHanlders = HandlerList<DidSetErrorsHanlder?>()
    
    public let validations: FieldValidations
    
    public var value: ValueType? {
        didSet {
            self.didSetValueHanlders.executeHandlers { [weak self] _, handler in
                handler?(self?.value)
            }
            
            self.didSetValueAnyHanlders.executeHandlers { [weak self] _, handler in
                guard let formField = self as? FormField else { return }
                handler?(formField, self?.value)
            }
        }
    }
    
    public var errors: FieldValidations = [] {
        didSet {
            self.didSetErrorsHanlders.executeHandlers { [weak self] _, handler in
                handler?(self?.errors ?? [])
            }
        }
    }
    
    public init(validations: FieldValidations, value: ValueType?) {
        self.validations = validations
        self.value = value
    }
    
    public func getValue() -> Encodable? {
        self.value
    }
    
    public func updateErrors(with mode: FieldValidation.Mode) {
        self.errors = self.validations.gotErrors(for: self.value, with: mode)
    }
    
    public func appendDidValueHandler(_ handler: DidSetValueHanlder?) -> HandlerKey {
        self.didSetValueHanlders.appendHandler(handler)
    }
    
    public func appendDidErrorsHandler(_ handler: DidSetErrorsHanlder?) -> HandlerKey {
        self.didSetErrorsHanlders.appendHandler(handler)
    }
    
}

open class FieldsForm {
    
    public var didChangeFieldValueHanlders = HandlerList<((FormField?) -> Void)?>()
    public var didChangeFieldErrorsHanlders = HandlerList<((FormField?) -> Void)?>()
    
    public init() {
        self.setupHandlers()
    }
    
    open func createErrors(with mode: FieldValidation.Mode) -> FieldValidations {
        var result: FieldValidations = []
        let mirror = Mirror(reflecting: self)
        
        mirror.children.forEach({ child in
            guard let field = child.value as? FormField else { return }
            
            field.updateErrors(with: mode)
            result += field.errors
        })
        
        return result
    }
    
    open func createDictionary() -> [String: Any?] {
        var result: [String: Any?] = [:]
        let mirror = Mirror(reflecting: self)
        
        mirror.children.forEach({ child in
            guard let key = child.label, let field = child.value as? FormField, let value = field.getValue() else { return }
            
            let dictionary = value.dictionary
            result[key] = dictionary?.isEmpty == false ? dictionary : value
        })
        
        return result
    }
    
    open func setupHandlers() {
        self.fields.forEach({ field in
            _ = field.didSetValueAnyHanlders.appendHandler { [weak self] field, _ in
                self?.didChangeFieldValueHanlders.executeHandlers({ _, handler in
                    handler?(field)
                })
            }
            
            _ = field.didSetErrorsAnyHanlders.appendHandler { [weak self] field, _ in
                self?.didChangeFieldErrorsHanlders.executeHandlers({ _, handler in
                    handler?(field)
                })
            }
        })
        
        let mirror = Mirror(reflecting: self)
        
        mirror.children.forEach({ child in
            guard let key = child.label, let field = child.value as? FormField, let value = field.getValue() else { return }
            
            _ = field.didSetValueAnyHanlders.appendHandler { [weak self] field, _ in
                self?.didChangeFieldValueHanlders.executeHandlers({ _, handler in
                    handler?(field)
                })
            }
        })
    }
    
    open var fields: [FormField] {
        let mirror = Mirror(reflecting: self)
        let result = mirror.children.filter({ $0 is FormField }) as? [FormField]
        return result ?? []
    }
    
}

public typealias HandlerKey = NSObject
public typealias HanlderTest<Input, Output> = (Input) -> Output

public class HandlerList<HanlderTest> {
    private var handlers: [HandlerKey: HanlderTest] = [:]
    
    public init() {}
    
    public func appendHandler(_ handler: HanlderTest) -> HandlerKey {
        let key = HandlerKey()
        self.handlers[key] = handler
        return key
    }
    
    public func removeHanlderOfKey(_ key: HandlerKey) {
        self.handlers.removeValue(forKey: key)
    }
    
    public func removeAllHanlders() {
        self.handlers.removeAll()
    }
    
    public func executeHandlers(_ execution: ((HandlerKey, HanlderTest) -> Void)?) {
        self.handlers.forEach({ key, handler in
            execution?(key, handler)
        })
    }
}
