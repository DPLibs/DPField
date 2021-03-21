import Foundation
import DPLibrary

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
    
    open func gotErrors(with mode: FieldValidation.Mode) -> FieldValidations {
        var result: FieldValidations = []
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard let field = child.value as? FormFieldProtocol else { return }

            result += field.gotErrors(with: mode)
        })

        return result
    }

    open func createDictionary() -> [String: Any] {
        var result: [String: Any] = [:]
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
