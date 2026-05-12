//
//  TeamDetails.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import Foundation

struct TeamDetails: Codable, Identifiable {
    let id: Int
    let name: String?
    let logo: String?

    let players: [Player]?
    let coaches: [Coach]?

    enum CodingKeys: String, CodingKey {
        case id = "team_key"
        case name = "team_name"
        case logo = "team_logo"
        case players
        case coaches
    }
    
    static func getEmptyTeamDetails() -> TeamDetails {
        TeamDetails(id: 0, name: "", logo: "", players: [], coaches: [])
    }
}
