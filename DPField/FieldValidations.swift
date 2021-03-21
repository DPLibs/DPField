import Foundation
import DPLibrary

public typealias FieldValidations = [FieldValidation]

public extension FieldValidations {
    
    func gotErrors(for value: Any?, with mode: FieldValidation.Mode) -> FieldValidations {
        let errors = self.map({ $0.gotError(for: value, with: mode) }).filter({ $0 != nil })
        return errors as? Self ?? []
    }
    
}
