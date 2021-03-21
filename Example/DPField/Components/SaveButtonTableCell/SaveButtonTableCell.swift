//
//  SaveButtonTableCell.swift
//  DPField
//
//  Created by Дмитрий Поляков on 21.03.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DPField

class SaveButtonTableCell: UITableViewCell {
    
    @IBOutlet private weak var button: UIButton!

    var model: SaveButtonTableCellModel? {
        didSet {
            self.updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupViews()
    }
    
    func setupViews() {
        self.button.setTitle("Save", for: .normal)
        self.button.addTarget(self, action: #selector(self.tapButton), for: .touchUpInside)
    }
    
    func updateViews() {}
    
    @objc
    private func tapButton() {
        self.model?.didTapButton?()
    }

}

class SaveButtonTableCellModel {

    public var cellIdentifier: String {
        "SaveButtonTableCell"
    }
    
    var didTapButton: (() -> Void)?
    
    init(didTapButton: (() -> Void)?) {
        self.didTapButton = didTapButton
    }
    
}
