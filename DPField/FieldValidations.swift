import Foundation

public typealias FieldValidations = [FieldValidation]

public extension FieldValidations {
    
    func gotErrors(for value: Any?, with mode: FieldValidation.Mode) -> FieldValidations {
        let errors = self.map({ $0.gotError(for: value, with: mode) }).filter({ $0 != nil })
        return errors as? Self ?? []
    }
    
    func validateShouldChangeCharacters(text: String?, in range: NSRange, replacementString string: String) -> FieldValidations {
        let errors = self.map({ $0.validateShouldChangeCharacters(text: text, in: range, replacementString: string) }).filter({ $0 != nil })
        return errors as? Self ?? []
    }
    
}

// MARK: - Store
public extension FieldValidations {
    
    static var isEmailDefault: FieldValidations {
        [.isEmailDefault]
    }
    
    static var isDateDefault: FieldValidations {
        [.isDateDefault]
    }
    
    static var isNumberDefault: FieldValidations {
        [.isNumberDefault]
    }
    
    static func maxLengthDefault(length: Int) -> FieldValidations {
        [.maxLengthDefault(length: length)]
    }
    
    static func minLengthDefault(length: Int) -> FieldValidations {
        [.minLengthDefault(length: length)]
    }
    
    static func matchPredicate(format: String) -> FieldValidations {
        [.matchPredicate(format: format)]
    }
    
}
