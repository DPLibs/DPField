import Foundation
import DPLibrary

public typealias FieldValidations = [FieldValidation]

public extension FieldValidations {
    
    func validate(for value: Any?, with mode: FieldValidation.Mode) -> FieldValidations {
        let errors = self.map({ $0.validate(for: value, with: mode) }).filter({ $0 != nil })
        return errors as? Self ?? []
    }
    
}
