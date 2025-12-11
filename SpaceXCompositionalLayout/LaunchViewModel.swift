//
//  LaunchViewModel.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 08.12.2025.
//

import Foundation

class LaunchViewModel {
    private let service: LaunchService
    private var launches: [Launch] = []
    
    init(service: LaunchService) {
        self.service = service
    }
    
    func loadLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
        service.getItemData { [weak self] result in
            switch result {
            case .success(let fetchedLaunches):
                self?.launches = fetchedLaunches
                completion(.success(fetchedLaunches))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
