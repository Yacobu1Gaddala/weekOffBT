//
//  UserModel.swift
//  WeekOffBT
//
//  Created by G Yacobu on 17/11/25.
//

import Foundation



struct UserObject: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    
    let address:AddressObj
    let phone: String
    let website: String
    let company: CompanyObj
}

struct CompanyObj: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct AddressObj: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo:GeoObj
}

struct GeoObj: Codable {
    let lat: String
    let lng: String
}






// GCD:-
func fetchUsers(completion: @escaping([UserObject]?) -> Void) {
    
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
        completion(nil)
        return
    }
    
    DispatchQueue.global(qos: .background).async {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in 
            
            if let error  = error {
                print("Error fetching users:", error)
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
                
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                    
                }
                return
            }
            do{
                let users = try JSONDecoder().decode([UserObject].self, from: data)
                DispatchQueue.main.async {
                    completion(users)
                }
            }catch {
                print("Error decoding Json",error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}

// OperationQueue:-


class OperationQueueWrapper: Operation {
    
    private let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
    var result:[UserObject]?
    var error: Error?
    
    
    
    override func main() {
        
        
        // If cancelled before starting , stop work
        if self.isCancelled {return}
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if self.isCancelled {
                semaphore.signal()
                return
            }
            
            
            if let err = error {
                self.error = err
                semaphore.signal()
                return
            }
            
            guard let data = data else {
                self.error = NSError(domain: "No data", code: -1, userInfo: nil)
                semaphore.signal()
                return
            }
            
            do {
                let users = try JSONDecoder().decode([UserObject].self, from: data)
                self.result = users
            }catch {
                self.error = error
            }
            semaphore.signal()
        }
        .resume()
        semaphore.wait() // Wait untill network task finishes
    }
    
    
}


