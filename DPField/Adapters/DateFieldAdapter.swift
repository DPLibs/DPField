import Foundation
import UIKit
import DPLibrary

// MARK: - Output
public protocol DateFieldAdapterOutput: AnyObject {
    func didErrors(adapter: DateFieldAdapter, errors: FieldValidations)
    func didControlEvent(adapter: DateFieldAdapter, event: UIControl.Event)
    func didDateChanged(adapter: DateFieldAdapter, date: Date?)
    func didTapClearButton(adapter: DateFieldAdapter)
}

public extension DateFieldAdapterOutput {
    func didErrors(adapter: DateFieldAdapter, errors: FieldValidations) {}
    func didControlEvent(adapter: DateFieldAdapter, event: UIControl.Event) {}
    func didDateChanged(adapter: DateFieldAdapter, date: Date?) {}
    func didTapClearButton(adapter: DateFieldAdapter) {}
}

// MARK: - Adapter
open class DateFieldAdapter: Field<Date>, UITextFieldDelegate {

    // MARK: - Props
    public weak var textField: UITextField? {
        didSet {
            self.textField?.delegate = self
            self.setDatePicker()
            self.didSetValue()
        }
    }
    
    public let datePicker = UIDatePicker()
    
    public var minDate: Date? {
        didSet {
            self.setDatePicker()
        }
    }
    
    public var maxDate: Date? {
        didSet {
            self.setDatePicker()
        }
    }
    
    public var dateFormatType: DateFormatType = .default
    
    public weak var output: DateFieldAdapterOutput?
    
    public override var value: Date? {
        didSet {
            self.didSetValue()
        }
    }

    public override var errors: FieldValidations {
        didSet {
            self.output?.didErrors(adapter: self, errors: self.errors)
        }
    }
    
    // MARK: - Init
    public init(minDate: Date?, maxDate: Date?, validations: FieldValidations, value: Date?) {
        self.minDate = minDate
        self.maxDate = maxDate
        
        super.init(validations: validations, value: value)
        
        self.datePicker.date = value ?? maxDate ?? .init()
    }
    
    // MARK: - Public methods
    open func provideControlEvent(_ event: UIControl.Event) {
        switch event {
        case .editingDidBegin:
            self.errors = []
        case .valueChanged,
             .editingChanged:
            self.createErrors(with: .realTime)
        case .editingDidEnd:
            self.createErrors(with: .any)
        default:
            break
        }

        self.output?.didControlEvent(adapter: self, event: event)
    }
    
    open func setDatePicker() {
        self.datePicker.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        
        if let minDate = self.minDate {
            self.datePicker.minimumDate = minDate
        }
        
        if let maxDate = self.maxDate {
            self.datePicker.maximumDate = maxDate
        }
        
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            self.datePicker.sizeToFit()
        }
        
        self.textField?.inputView = self.datePicker
    }
    
    open func didSetValue() {
        self.textField?.text = self.value?.toLocalString(withFormatType: self.dateFormatType)
        self.output?.didDateChanged(adapter: self, date: self.value)
    }
    
    // MARK: - Private methods
    @objc
    private func datePickerValueChanged() {
        self.value = self.datePicker.date
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
        let errors = self.validations.map({ $0.gotError(for: updatedText, with: .realTime) }).filter({ $0 != nil })
        self.errors = errors as? FieldValidations ?? []
        return errors.isEmpty
    }

}
