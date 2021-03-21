//
//  ViewController.swift
//  DPField
//
//  Created by Dmitriy Polyakov on 03/16/2021.
//  Copyright (c) 2021 Dmitriy Polyakov. All rights reserved.
//

import UIKit
import DPField
import DPLibrary

class ViewController: UIViewController {
    
    private let table = UITableView()
    private var rows: [Any] = []
    
    private let userProfile = UserProfile()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.endEditingOnTap()
        self.setTable()
        
        self.rows = self.createRows()
        self.table.reloadData()
    }
    
    private func setTable() {
        self.table.removeFromSuperview()
        self.table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.table)
        
        let guide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.table.topAnchor.constraint(equalTo: guide.topAnchor),
            self.table.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            self.table.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            self.table.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
        
        self.table.apply([.tableDefault])
        
        self.table.registerCellNibs([
            TextFieldTableCell.self,
            DateTableCell.self,
            SaveButtonTableCell.self
        ])
        
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    private func createRows() -> [Any] {
        [
            TextFieldTableCellModel(placehodler: "FirstName", texFieldAdapter: self.userProfile.firstName),
            TextFieldTableCellModel(placehodler: "LastName", texFieldAdapter: self.userProfile.lastName),
            TextFieldTableCellModel(placehodler: "MiddleName", texFieldAdapter: self.userProfile.middleName),
            
            DateTableCellModel(placehodler: "BirthDate", dateFieldAdapter: self.userProfile.birthDate),
            
            SaveButtonTableCellModel(didTapButton: { [weak self] in
                self?.tapSave()
            })
        ]
    }
    
    private func tapSave() {
        let errors = self.userProfile.createErrors(with: .afterFinish)
        
        guard errors.isEmpty else {
            self.table.reloadData()
            return
        }
        
        let dictionary = self.userProfile.createDictionary()
        
        let alert = UIAlertController(title: "Success!", message: "Dictionary created: \(dictionary)", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.rows.element(at: indexPath.row) else { return UITableViewCell() }
        
        switch model {
        case let textFieldModel as TextFieldTableCellModel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: textFieldModel.cellIdentifier, for: indexPath) as? TextFieldTableCell else { return UITableViewCell() }
            cell.model = textFieldModel
            return cell
        case let saveButtonModel as SaveButtonTableCellModel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: saveButtonModel.cellIdentifier, for: indexPath) as? SaveButtonTableCell else { return UITableViewCell() }
            cell.model = saveButtonModel
            return cell
        case let dateModel as DateTableCellModel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: dateModel.cellIdentifier, for: indexPath) as? DateTableCell else { return UITableViewCell() }
            cell.model = dateModel
            return cell
        default:
            return UITableViewCell()
        }
    }

}
