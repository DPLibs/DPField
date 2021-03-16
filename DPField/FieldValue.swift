import Foundation

struct TestEncodable: Encodable {
    let testE1: String
    let testE2: Int
}

class TestFieldsForm: FieldsForm {
    let test1: Field<String>
    let test2: Field<Int>
    let test3: Field<TestEncodable>
    
    init(test1: Field<String>, test2: Field<Int>, test3: Field<TestEncodable>) {
        self.test1 = test1
        self.test2 = test2
        self.test3 = test3
    }
}

public protocol FieldValidatable {
    var errors: FieldValidations { get set }
    
    func getValue() -> Encodable?
    func updateErrors(with mode: FieldValidation.Mode)
}

open class Field<ValueType: Encodable>: NSObject, FieldValidatable {
    public let validations: FieldValidations
    
    public var value: ValueType? {
        didSet {
            self.didSetValue?(self.value)
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

public protocol FieldsForm: AnyObject {}
    
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
