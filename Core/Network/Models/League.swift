//
//  League.swift
//  Sporta
//
//  Created by Hossam on 06/05/2026.
//

import Foundation


struct League: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String?
    let logo: String?
    let countryLogo: String?

    enum CodingKeys: String, CodingKey {
        case id = "league_key"
        case name = "league_name"
        case country = "country_name"
        case logo = "league_logo"
        case countryLogo = "country_logo"
    }
}

