import Foundation

public protocol FieldValidatable {
    var errors: FieldValidations { get set }
    
    func getValue() -> Encodable?
    func updateErrors(with mode: FieldValidation.Mode)
}

open class Field<ValueType: Encodable>: NSObject, FieldValidatable {
    
    public let didSetValueHanlders = HandlerList<((ValueType?) -> Void)?>()
    public let didSetErrorsHanlders = HandlerList<((FieldValidations) -> Void)?>()
    
    public let validations: FieldValidations
    
    public var value: ValueType? {
        didSet {
            self.didSetValue?(self.value)
            
            self.didSetValueHanlders.executeHandlers { [weak self] _, handler in
                handler?(self?.value)
            }
        }
    }
    
    public var errors: FieldValidations = [] {
        didSet {
            self.didSetErrors?(self.errors)
        }
    }
    
    public var didSetValue: ((ValueType?) -> Void)?
    public var didSetErrors: (([FieldValidation]) -> Void)?
    
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
    
}

public protocol FieldsForm: AnyObject {
    func createErrors(with mode: FieldValidation.Mode) -> FieldValidations
    func createDictionary() -> [String: Any?]
}
    
public extension FieldsForm {
    
    func createErrors(with mode: FieldValidation.Mode) -> FieldValidations {
        var result: FieldValidations = []
        let mirror = Mirror(reflecting: self)
        
        mirror.children.forEach({ child in
            guard let field = child.value as? FieldValidatable else { return }
            
            field.updateErrors(with: mode)
            result += field.errors
        })
        
        return result
    }
    
    func createDictionary() -> [String: Any?] {
        var result: [String: Any?] = [:]
        let mirror = Mirror(reflecting: self)
        
        mirror.children.forEach({ child in
            guard let key = child.label, let field = child.value as? FieldValidatable, let value = field.getValue() else { return }
            
            let dictionary = value.dictionary
            result[key] = dictionary?.isEmpty == false ? dictionary : value
        })
        
        return result
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
