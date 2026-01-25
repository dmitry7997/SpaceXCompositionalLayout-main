//
//  LaunchViewModel.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 08.12.2025.
//

import Foundation

class LaunchViewModel {
    private let service: LaunchService
    
    init(service: LaunchService) {
        self.service = service
    }
    
    func loadLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
        service.getItemData { (result: Result<[Launch], Error>) in
            completion(result)
        }
    }
}
