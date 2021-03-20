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
