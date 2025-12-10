//
//  RocketViewModel.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 27.11.2025.
//

import Foundation

class RocketViewModel {
    private var rockets: [Rocket] = []
    private let service: RocketService
    private var selectedRocketIndex: Int = 0
    
    init(service: RocketService) {
        self.service = service
    }
    
    var currentPage: Int { selectedRocketIndex }
    
    var currentRocket: Rocket? {
        guard selectedRocketIndex >= 0 && selectedRocketIndex < rockets.count else { return nil }
        return rockets[selectedRocketIndex]
    }
    var totalRockets: Int { rockets.count }
    
    var carouselData: [(value: String, title: String)] {
        guard let rocket = currentRocket else { return [] }
        return [
            (String(rocket.height?.feet ?? 0), "Высота"),
            (String(rocket.diameter?.feet ?? 0), "Диаметр"),
            (String(rocket.mass?.lb ?? 0), "Масса"),
            {
                let leoPayload = rocket.payloadWeights?.first(where: { $0.id == "leo" })
                return (String(leoPayload?.lb ?? 0), "Leo")
            }()
        ]
    }
    
    var stageData: [(stage: Rocket.Stage?, title: String)] {
        guard let rocket = currentRocket else { return [] }
        return [
            (stage: rocket.firstStage, title: "ПЕРВАЯ СТУПЕНЬ"),
            (stage: rocket.secondStage, title: "ВТОРАЯ СТУПЕНЬ")
        ]
    }
    
    func loadRockets(completion: @escaping (Result<Void, Error>) -> Void) {
        service.getItemData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedRockets):
                self.rockets = fetchedRockets
                if !self.rockets.isEmpty {
                    self.selectedRocketIndex = 0
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func selectRocket(at index: Int) {
        guard index >= 0 && index < totalRockets else { return }
        selectedRocketIndex = index
    }
    
    func selectNextRocket() {
        selectRocket(at: (selectedRocketIndex + 1) % totalRockets)
    }
    
    func selectPreviousRocket() {
        selectRocket(at: (selectedRocketIndex - 1 + totalRockets) % totalRockets)
    }
}
