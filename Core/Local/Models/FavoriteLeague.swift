//
//  FavoriteLeague.swift
//  Sporta
//
//  Created by Hossam on 09/05/2026.
//

import Foundation

struct FavoriteLeague: Identifiable {
    let id: Int
    let name: String
    let country: String
    let logo: String
    let countryLogo: String
    let sport: Sport
}

extension FavoriteLeague {
    func toLeague() -> League {
        League(id: id, name: name, country: country, logo: logo, countryLogo: countryLogo)
    }
}
