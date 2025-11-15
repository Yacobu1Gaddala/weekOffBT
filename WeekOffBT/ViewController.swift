//
//  ViewController.swift
//  WeekOffBT
//
//  Created by G Yacobu on 15/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var homeTableView: UITableView = {
        let tableView = UITableView()
        return tableView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.frame = view.bounds
        self.view.addSubview(homeTableView)
        
    }


}

