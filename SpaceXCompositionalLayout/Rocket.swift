//
//  Rocket.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 07.11.2025.
//

import Foundation

// сгенерил через gpt
struct Rocket: Decodable {
    let name: String
    let type: String
    let active: Bool
    let stages: Int
    let boosters: Int
    let costPerLaunch: Int
    let successRatePct: Int
    let firstFlight: String
    let country: String
    let company: String
    let wikipedia: String
    let description: String
    let id: String
    
    let height: Measurement?
    let diameter: Measurement?
    let mass: Mass?
    
    let firstStage: Stage?
    let secondStage: Stage?
    
    let engines: Engine?
    
    let landingLegs: LandingLegs?
    
    let payloadWeights: [PayloadWeight]?
    
    let flickrImages: [String]?
    
    struct Measurement: Decodable {
        let meters: Double?
        let feet: Double?
    }
    
    struct Mass: Decodable {
        let kg: Int?
        let lb: Int?
    }
    
    struct Stage: Decodable {
        let thrustSeaLevel: Thrust?
        let thrustVacuum: Thrust?
        let reusable: Bool?
        let engines: Int?
        let fuelAmountTons: Double?
        let burnTimeSec: Int?
        
        let thrust: Thrust?
        let payloads: Payloads?
        
        struct Thrust: Decodable {
            let kN: Double?
            let lbf: Double?
        }
        
        struct Payloads: Decodable {
            let compositeFairing: Fairing?
            let option1: String?
            
            struct Fairing: Decodable {
                let height: Measurement?
                let diameter: Measurement?
            }
        }
    }
    
    struct Engine: Decodable {
        let isp: ISP?
        let thrustSeaLevel: Thrust?
        let thrustVacuum: Thrust?
        let number: Int?
        let type: String?
        let version: String?
        let layout: String?
        let engineLossMax: Int?
        let propellant1: String?
        let propellant2: String?
        let thrustToWeight: Double?
        
        struct ISP: Decodable {
            let seaLevel: Int?
            let vacuum: Int?
        }
        
        struct Thrust: Decodable {
            let kN: Double?
            let lbf: Double?
        }
    }
    
    struct LandingLegs: Decodable {
        let number: Int?
        let material: String?
    }
    
    struct PayloadWeight: Decodable {
        let id: String?
        let name: String?
        let kg: Int?
        let lb: Int?
    }
}

//struct RoclerItemsResponse: Decodable {
//    let rocketItems: [Rocket]
//}
