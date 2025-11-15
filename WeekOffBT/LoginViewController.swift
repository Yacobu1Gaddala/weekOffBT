//
//  ViewController.swift
//  WeekOffBT
//
//  Created by G Yacobu on 15/11/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.frame = view.bounds
        self.view.addSubview(homeTableView)
        
    }


}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return cell
    }
}
