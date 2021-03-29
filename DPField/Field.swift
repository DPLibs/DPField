import Foundation
import DPLibrary

open class Field<Value: Equatable>: NSObject, FormFieldProtocol {
    
    // MARK: - Props
    public typealias DidSetValueHanlder = (Value?) -> Void
    public typealias DidSetErrorsHanlder = (FieldValidations) -> Void
    
    private var didSetValueHanlders = Handlers<DidSetValueHanlder?>()
    private var didSetErrorsHanlders = Handlers<DidSetErrorsHanlder?>()
    
    public let validations: FieldValidations

    open var value: Value? {
        didSet {
            self.didSetValueHanlders.execute { [weak self] _, handler in
                handler?(self?.value)
            }
            
            self.didChangeFieldValueHanlders.execute { [weak self] _, handler in
                handler?(self)
            }
        }
    }
    
    open var errors: FieldValidations = [] {
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
    
    open func getValue() -> Any? {
        self.value
    }
    
    open func getErrors() -> FieldValidations {
        self.errors
    }
    
    open func generateErrors(with mode: FieldValidation.Mode) {
        self.errors = self.validations.validate(for: self.value, with: mode)
    }
    
    open func validate(with mode: FieldValidation.Mode) -> FieldValidations {
        self.validations.validate(for: self.value, with: mode)
    }
    
    open func isEqualToFieldValue(_ fieldValue: Any?) -> Bool {
        self.value == (fieldValue as? Value)
    }
}




