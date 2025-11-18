//
//  ViewController.swift
//  WeekOffBT
//
//  Created by G Yacobu on 15/11/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    let todoServ = TodoService()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers { users in
            print(users ?? [])
        }
        
        
        
        
        
        let queue = OperationQueue()
        let fetchOp = OperationQueueWrapper()
        fetchOp.completionBlock = {
            DispatchQueue.main.async {
                if let error = fetchOp.error {
                    print("Error", error.localizedDescription)
                    return
                }
                
                if let users = fetchOp.result {
                    for user in users {
                        print("User:", user.name)
                    }
                }
 
            }
        }
        
        queue.addOperation(fetchOp)
        
        
       
        todoServ.loadTodos() 
        
    }


}


