//
//  Launch.swift
//  SpaceXCompositionalLayout
//
//  Created by Not Null on 08.12.2025.
//

import Foundation
// в API не нашел соответствия(может быть устарело) использовал заглушки
struct Launch: Decodable {
    let id: String
    let name: String
    let dateUtc: String
    let success: Bool?
}
