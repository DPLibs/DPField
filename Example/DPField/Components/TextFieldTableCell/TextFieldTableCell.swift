//
//  TextFieldTableCell.swift
//  DPField
//
//  Created by Дмитрий Поляков on 21.03.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DPField

class TextFieldTableCell: UITableViewCell {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorLb: UILabel!

    var model: TextFieldTableCellModel? {
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
        model.texFieldAdapter.textField = self.textField
        model.texFieldAdapter.output = self
    }

}

extension TextFieldTableCell: TextFieldAdapterOutput {
    
    func didErrors(adapter: TextFieldAdapter, errors: FieldValidations) {
        let message = errors.first?.message
        
        guard self.errorLb.text != message else { return }
        self.errorLb.text = message
        self.reloadCellView()
    }
    
}

class TextFieldTableCellModel {

    public var cellIdentifier: String {
        "TextFieldTableCell"
    }
    
    let placehodler: String
    let texFieldAdapter: TextFieldAdapter
    
    init(placehodler: String, texFieldAdapter: TextFieldAdapter) {
        self.placehodler = placehodler
        self.texFieldAdapter = texFieldAdapter
    }
    
}
