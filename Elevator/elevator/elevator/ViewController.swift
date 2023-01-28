//
//  ViewController.swift
//  elevator
//
//  Created by ddy on 2023/1/16.
//

import UIKit
import DDYSwiftyExtension

class DDYTableCell: UITableViewCell {
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        let table = UITableView()
        table.ddy_registers(cells: [DDYTableCell.self, UITableViewCell.self])
    }
}

