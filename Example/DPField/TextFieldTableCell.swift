//
//  TextFieldTableCell.swift
//  DPField
//
//  Created by Дмитрий Поляков on 21.03.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import GKRepresentable

class TextFieldTableCell: TableCell {

    // MARK: - Outlet
    @IBOutlet weak var textField: UITextField!

    // MARK: - Override
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        return
    }
    
    override func setupView() { }

    override func updateViews() {
        guard let model = self.model as? TextFieldTableCellModel else { return }
    }
    
    // MARK: - Actions
    @objc
    private func tapButton(_ sender: UIButton) {
        guard let model = self.model as? TextFieldTableCellModel else { return }
    }
    
    @objc
    private func tapGesture(_ gesture: UITapGestureRecognizer) {
        guard let model = self.model as? TextFieldTableCellModel else { return }
    }

}
