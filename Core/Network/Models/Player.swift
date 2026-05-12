//
//  Player.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import Foundation

struct Player: Codable, Identifiable {
    var id: UUID = UUID()

    let name: String?
    let image: String?
    let number: String?
    let type: String?
    let age: String?

    enum CodingKeys: String, CodingKey {
        case name = "player_name"
        case image = "player_image"
        case number = "player_number"
        case type = "player_type"
        case age = "player_age"
    }
    
    static func getEmptyPlayrt() -> Player {
        Player(name: nil, image: nil, number: nil, type: nil, age: nil)
    }
}
