//
//  TodoModel.swift
//  WeekOffBT
//
//  Created by G Yacobu on 18/11/25.
//

import Foundation

struct TodoModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}



// Make a Network Manager Using combine
import Combine


class TodoService {
    
    // A set that stores your combine subscriptions.
    // without storing them, combine cancels the request immediately
    private var cancellables = Set<AnyCancellable>()
    // Declares a function that returns a combine publisher
    // this publisher will eventually output either:
    func fetchTodos() -> AnyPublisher<[TodoModel], Error> {
        
        // Create Url
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            // if URL is invalid:
            // create a Fail publisher that immediately sends an error.
            return Fail(error: URLError(.badURL))
            // hides internal typs (Clean API)
                .eraseToAnyPublisher()
        }
        // Network Request as publisher
        // Starts a network request.
        // Datatask publisher creates a publisher that:
        // makes the Http request
        // publishes (data, response)
        return URLSession.shared.dataTaskPublisher(for: url)
        
        //Allows you to throw an error inside the closure
        // Gets the raw data and response from the network
            .tryMap { data, resonse -> Data in
                
                if let httpResponse = resonse as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return data
            }
        
            .decode(type: [TodoModel].self, decoder: JSONDecoder())
        // 👉 Makes the subscriber receive values on the main thread.
        // 👉 Important if you're updating UI later.
            .receive(on: DispatchQueue.main)
        //👉 Removes the internal pipeline type, returning a simple AnyPublisher.
            .eraseToAnyPublisher()
        
    }
    
    
    func loadTodos() {
        
        fetchTodos()
        //👉 Attaches a subscriber that listens for:
        //  completion (finished or error)
        //  value (decoded todos)
            .sink(receiveCompletion: { completion in 
                switch completion {
                case .finished:
                    print("finished") 
                    
                case .failure(let error):
                    print("getting :\(error)")
                }
                
            }, receiveValue: { todos in 
                for todo in todos {
                    print("Todo #\(todo.id): \(todo.title) — completed: \(todo.completed)")
                }
                
            })
        //👉 Saves the subscription.
        //👉 Required to prevent it from getting cancelled immediately.
            .store(in: &cancellables)
    }
    
}
