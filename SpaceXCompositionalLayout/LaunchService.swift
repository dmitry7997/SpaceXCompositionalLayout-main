//
//  LaunchService.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 08.12.2025.
//

import Foundation

protocol LaunchServiceProtocol {
    func getItemData<T: Decodable>(completion: @escaping (Result<[T], Error>) -> Void)
}

final class LaunchService: LaunchServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getItemData<T: Decodable>(completion: @escaping (Result<[T], Error>) -> Void) {
        
        guard let url = URL(string: "https://api.spacexdata.com/v4/launches") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            let result: Result<[T], Error>
            
            if let error = error {
                result = .failure(error)
            } else if let data = data {
                do{
                    let response = try self.decoder.decode([T].self, from: data)
                    result = .success(response)
                } catch {
                    print("\(error.localizedDescription)")
                    result = .failure(error)
                }
                
            } else {
                result = .failure(NSError(domain: "No data", code: 0, userInfo: nil))
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
}
