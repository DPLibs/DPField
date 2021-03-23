import Foundation
import DPLibrary

open class FormFields: NSObject {
    
    // MARK: - Props
    public typealias DidChangeFieldHanlder = (FormFieldProtocol?) -> Void
    public typealias DidChangeErrorsHanlder = (FormFieldProtocol?) -> Void
    
    private var didChangeFieldValueHanlders = Handlers<DidChangeFieldHanlder?>()
    private var didChangeFieldErrorsHanlders = Handlers<DidChangeErrorsHanlder?>()
    
    private var dictionaryBeforeChanged: [String: Any] = [:]

    // MARK: - Init
    public override init() {
        super.init()
        
        self.setupHandlers()
        self.dictionaryBeforeChanged = self.createDictionary()
    }

    // MARK: - Public methods
    public var isChanged: Bool {
        var result: Bool = false
        let dict = self.dictionaryBeforeChanged
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard let field = child.value as? FormFieldProtocol, let key = child.label else { return }
            
            guard !field.isEqualToFieldValue(dict[key]) else { return }
            result = true
        })

        return result
    }
    
    open func getErrors() -> FieldValidations {
        var result: FieldValidations = []
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard let field = child.value as? FormFieldProtocol else { return }

            result += field.getErrors()
        })

        return result
    }
    
    open func generateErrors(with mode: FieldValidation.Mode) {
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard let field = child.value as? FormFieldProtocol else { return }

            field.generateErrors(with: mode)
        })
    }
    
    open func validate(with mode: FieldValidation.Mode) -> FieldValidations {
        var result: FieldValidations = []
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard let field = child.value as? FormFieldProtocol else { return }

            result += field.validate(with: mode)
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
    
    public func createDictionary() -> [String: Any] {
        var result: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach({ child in
            guard let field = child.value as? FormFieldProtocol, let label = child.label, let value = field.getValue() else { return }
            
            result[label] = value
        })

        return result
    }
}
