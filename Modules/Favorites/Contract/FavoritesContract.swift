//
//  FavoritesContract.swift
//  Sporta
//
//  Created by Hossam on 09/05/2026.
//

import Foundation

protocol FavoritesPresenterProtocol {
    var leagues: [FavoriteLeague] { get }
    func delete(league: FavoriteLeague)
    func insert(league: FavoriteLeague)
    func reloadData()
}

protocol FavoritesViewProtocol: AnyObject {
    func reloadData()
    func show(title: String, message: String)
}
