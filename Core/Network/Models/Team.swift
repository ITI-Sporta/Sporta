//
//  Team.swift
//  Sporta
//
//  Created by Hossam on 06/05/2026.
//

import Foundation


struct Team: Codable, Identifiable {
    let id: Int
    let name: String
    let logo: String?

    enum CodingKeys: String, CodingKey {
        case id = "team_key"
        case name = "team_name"
        case logo = "team_logo"
    }
}
