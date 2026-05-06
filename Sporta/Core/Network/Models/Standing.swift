//
//  Standing.swift
//  Sporta
//
//  Created by Hossam on 06/05/2026.
//

import Foundation


struct StandingsResult: Codable {
    let total: [Standing]?
}

struct Standing: Codable, Identifiable {
    let id: Int
    let teamName: String?
    let teamLogo: String?
    let position: Int?
    let played: Int?
    let won: Int?
    let drawn: Int?
    let lost: Int?
    let goalsFor: Int?
    let goalsAgainst: Int?
    let goalsDiff: Int?
    let points: Int?

    enum CodingKeys: String, CodingKey {
        case id = "team_key"
        case teamName = "standing_team"
        case teamLogo = "team_logo"
        case position = "standing_place"
        case played = "standing_P"
        case won = "standing_W"
        case drawn = "standing_D"
        case lost = "standing_L"
        case goalsFor = "standing_F"
        case goalsAgainst = "standing_A"
        case goalsDiff = "standing_GD"
        case points = "standing_PTS"
    }

}

