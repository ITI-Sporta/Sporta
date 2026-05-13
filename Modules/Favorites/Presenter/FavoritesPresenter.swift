//
//  FavoritesPresenter.swift
//  Sporta
//
//  Created by Hossam on 09/05/2026.
//

import Foundation


class FavoritesPresenter: FavoritesPresenterProtocol {
    
    private weak var view: FavoritesViewProtocol?
    private let db: DatabaseProtocol = CoreDataManager.shared
    
    init(view: FavoritesViewProtocol) {
        self.view = view
        reloadData()
    }
    
    var leagues: [FavoriteLeague] = []
        
    func delete(league: FavoriteLeague) {
        let success = db.deleteFavoriteLeague(by: league.id)
        
        if success {
            leagues.removeAll {
                $0.id == league.id
            }
            view?.show(type: .info, message: "Deleted \(league.name) from favorites")
        } else {
            view?.show(type: .error, message: "Unable to delete \(league.name) from favorites")
        }
    }
    
    func insert(league: FavoriteLeague) {
        let success = db.addFavoriteLeague(league)
        
        if success {
            view?.show(type: .info, message: "Added \(league.name) to favorites")
        } else {
            view?.show(type: .error, message: "Unable to add \(league.name) to favorites")
        }
    }
    
    func reloadData() {
        leagues = db.getAllFavoriteLeagues()
        view?.reloadData()
    }
}
