//
//  FavoritesContract.swift
//  Sporta
//
//  Created by Hossam on 09/05/2026.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func delete(league: FavoriteLeague)
    func insert(league: FavoriteLeague)
    func reloadData()
    func isConnected() -> Bool
    func getLeaguesCount() -> Int
    func getLeague(at index: Int) -> FavoriteLeague
}

protocol FavoritesViewProtocol: AnyObject {
    func reloadData()
    func deleteRowFromTable(at index: Int)
    func reloadRowForEmptyState(at index: Int)
    func show(type: ToastType, message: String)
}
