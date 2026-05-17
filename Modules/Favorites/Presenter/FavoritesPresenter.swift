//
//  FavoritesPresenter.swift
//  Sporta
//
//  Created by Hossam on 09/05/2026.
//

import Foundation
import SystemConfiguration
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
            let targetIndex = leagues.firstIndex(where: { $0.id == league.id })
            leagues.removeAll {
                $0.id == league.id
            }
            
            if let index = targetIndex {
                if leagues.isEmpty {
                    view?.reloadRowForEmptyState(at: index)
                } else {
                    view?.deleteRowFromTable(at: index)
                }
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
    
    func isConnected() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
    
    func getLeaguesCount() -> Int {
        leagues.count
    }
    
    func getLeague(at index: Int) -> FavoriteLeague {
        leagues[index]
    }
}
