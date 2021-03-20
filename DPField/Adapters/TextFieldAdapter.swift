import Foundation
import UIKit
import DPLibrary

// MARK: - Output
public protocol TextFieldAdapterOutput: AnyObject {
    func didErrors(adapter: TextFieldAdapter, errors: FieldValidations)
    func didControlEvent(adapter: TextFieldAdapter, event: UIControl.Event)
    func didTextChanged(adapter: TextFieldAdapter, text: String?)
    func didTapClearButton(adapter: TextFieldAdapter)
}

public extension TextFieldAdapterOutput {
    func didErrors(adapter: TextFieldAdapter, errors: FieldValidations) {}
    func didControlEvent(adapter: TextFieldAdapter, event: UIControl.Event) {}
    func didTextChanged(adapter: TextFieldAdapter, text: String?) {}
    func didTapClearButton(adapter: TextFieldAdapter) {}
}

// MARK: - Adapter
open class TextFieldAdapter: Field<String>, UITextFieldDelegate {

    // MARK: - Props
    public weak var textField: UITextField? {
        didSet {
            self.textField?.delegate = self
            self.textField?.addTarget(self, action: #selector(self.editingChanged(_:)), for: .editingChanged)
        }
    }
    
    public weak var output: TextFieldAdapterOutput?
    
    public override var value: String? {
        didSet {
            self.output?.didTextChanged(adapter: self, text: self.textField?.text)
        }
    }
    
    public override var errors: FieldValidations {
        didSet {
            self.output?.didErrors(adapter: self, errors: self.errors)
        }
    }
    
    private func provideControlEvent(_ event: UIControl.Event) {
        switch event {
        case .editingDidBegin:
            self.errors = []
            self.value = self.textField?.text
        case .valueChanged,
             .editingChanged:
            self.value = self.textField?.text
            self.createErrors(with: .realTime)
        case .editingDidEnd:
            self.value = self.textField?.text
            self.createErrors(with: .any)
        default:
            break
        }

        self.output?.didControlEvent(adapter: self, event: event)
    }

    @objc
    private func editingChanged(_ textField: UITextField) {
        self.provideControlEvent(.editingChanged)
    }
    
    // MARK: - UITextFieldDelegate
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.provideControlEvent(.editingDidBegin)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.provideControlEvent(.editingDidEnd)
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.output?.didTapClearButton(adapter: self)
        self.value = nil
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else { return true }
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        let errors = self.validations.map({ $0.gotError(for: updatedText, with: .realTime) })
        return errors.isEmpty
    }

}
