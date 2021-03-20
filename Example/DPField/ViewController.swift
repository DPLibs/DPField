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

class TestForm: FormFields {
    let field1: Field<String>
    let field2: Field<Int>
    
    init(field1: Field<String>, field2: Field<Int>) {
        self.field1 = field1
        self.field2 = field2
        
        super.init()
    }
}

class ViewController: UIViewController {
    
    private let table = UITableView()
//    private var rows: [TableCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTable()
//        self.table.delegate = self
//        self.table.dataSource = self
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
    }

}

//// MARK: - UITableViewDelegate
//extension ViewController: UITableViewDelegate {
//
//
//
//}
//
//// MARK: - UITableViewDataSource
//extension ViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.rows.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let  let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
//    }
//
//}
