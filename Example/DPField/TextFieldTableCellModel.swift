//
//  TextFieldTableCellModel.swift
//  DPField
//
//  Created by Дмитрий Поляков on 21.03.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import GKRepresentable
import DPField

class TextFieldTableCellModel: TableCellModel {

    // MARK: - Override
    public override var cellIdentifier: String {
        TextFieldTableCell.identifier
    }
    
    // MARK: - Props
    let placeholder: String
    let textFieldAdapter: TextFieldAdapter
    
    // MARK: - Init
    init(placeholder: String, textFieldAdapter: TextFieldAdapter) {
        self.placeholder = placeholder
        self.textFieldAdapter = textFieldAdapter
    }
}
