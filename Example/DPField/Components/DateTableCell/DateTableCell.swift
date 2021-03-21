//
//  DateTableCell.swift
//  DPField
//
//  Created by Дмитрий Поляков on 21.03.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DPField

class DateTableCell: UITableViewCell {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorLb: UILabel!

    var model: DateTableCellModel? {
        didSet {
            self.updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupViews()
    }
    
    func setupViews() {
        self.errorLb.textColor = .red
        self.errorLb.font = .systemFont(ofSize: 12)
    }
    
    func updateViews() {
        guard let model = self.model else { return }
        
        self.textField.placeholder = model.placehodler
        model.dateFieldAdapter.textField = self.textField
        model.dateFieldAdapter.output = self
    }
}

extension DateTableCell: DateFieldAdapterOutput {
    
    func didControlEvent(adapter: DateFieldAdapter, event: UIControl.Event) {
        switch event {
        case .editingDidBegin:
            adapter.value = adapter.datePicker.date
        default:
            break
        }
    }
    
    func didErrors(adapter: DateFieldAdapter, errors: FieldValidations) {
        let message = errors.first?.message
        
        guard self.errorLb.text != message else { return }
        self.errorLb.text = message
        self.reloadCellView()
    }
    
}

class DateTableCellModel {

    public var cellIdentifier: String {
        "DateTableCell"
    }
    
    let placehodler: String
    let dateFieldAdapter: DateFieldAdapter
    
    init(placehodler: String, dateFieldAdapter: DateFieldAdapter) {
        self.placehodler = placehodler
        self.dateFieldAdapter = dateFieldAdapter
    }
    
}
