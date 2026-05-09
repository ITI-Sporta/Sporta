//
//  DatabaseProtocol.swift
//  Sporta
//
//  Created by Hossam on 09/05/2026.
//

import Foundation

protocol DatabaseProtocol {
    
    func getFavoriteLeague(by id: Int) -> FavoriteLeague?
    func isFavoriteLeague(id: Int) -> Bool
    func deleteFavoriteLeague(by id: Int) -> Bool
    func getAllFavoriteLeagues() -> [FavoriteLeague]
    func addFavoriteLeague(_ league: FavoriteLeague) -> Bool
    
}
