//
//  ImageServiceProtocol.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 26.11.2025.
//

import UIKit

protocol ImageServiceProtocol {
    func loadImage(from imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ImageService: ImageServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadImage(from imageUrl: URL, completion: @escaping (Result<UIImage, any Error>) -> Void) {
        let task = session.dataTask(with: imageUrl) { data, response, error in
            
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            guard let data else {
                print("\(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    print("\(String(describing: error?.localizedDescription))")
                    
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        task.resume()
    }
}
