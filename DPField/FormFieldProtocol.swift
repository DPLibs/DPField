import Foundation
import DPLibrary

public protocol FormFieldProtocol {
    var didChangeFieldValueHanlders: Handlers<((FormFieldProtocol?) -> Void)?> { get set }
    var didChangeFieldErrorsHanlders: Handlers<((FormFieldProtocol?) -> Void)?> { get set }
    
    func getValue() -> Any?
    func getErrors() -> FieldValidations
    func generateErrors(with mode: FieldValidation.Mode)
    func validate(with mode: FieldValidation.Mode) -> FieldValidations
    func isEqualToFieldValue(_ fieldValue: Any?) -> Bool
}
