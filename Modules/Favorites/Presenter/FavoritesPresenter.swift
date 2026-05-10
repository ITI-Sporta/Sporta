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
            view?.show(title: "Success", message: "Deleted \(league.name) from favorites")
        } else {
            view?.show(title: "Error", message: "Unable to delete \(league.name) from favorites")
        }
    }
    
    func insert(league: FavoriteLeague) {
        let success = db.addFavoriteLeague(league)
        
        if success {
            view?.show(title: "Success", message: "Added \(league.name) to favorites")
        } else {
            view?.show(title: "Error", message: "Unable to add \(league.name) to favorites")
        }
    }
    
    func reloadData() {
        leagues = db.getAllFavoriteLeagues()
        view?.reloadData()
    }
}
