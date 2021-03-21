import Foundation
import DPLibrary

public protocol FormFieldProtocol {
    
    var didChangeFieldValueHanlders: Handlers<((FormFieldProtocol?) -> Void)?> { get set }
    var didChangeFieldErrorsHanlders: Handlers<((FormFieldProtocol?) -> Void)?> { get set }
    
    var needAppendToDictionary: Bool { get }
    
    func getValue() -> Any?
    func getErrors() -> FieldValidations

    func createErrors(with mode: FieldValidation.Mode)
    func gotErrors(with mode: FieldValidation.Mode) -> FieldValidations
    
    func keyForDictionary() -> String?
    func valueForDictionary() -> Any?
}
