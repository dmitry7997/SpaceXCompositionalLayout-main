//
//  RocketService.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 07.11.2025.
//

import Foundation

protocol RocketServiceProtocol {
    func getItemData(completion: @escaping (Result<[Rocket], Error>) -> Void)
}

final class RocketService: RocketServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getItemData(completion: @escaping (Result<[Rocket], Error>) -> Void) {
        
        guard let url = URL(string: "https://api.spacexdata.com/v4/rockets")
        else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                }
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode([Rocket].self, from: data)
                //let items = response.rocketItems
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    print("\(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
