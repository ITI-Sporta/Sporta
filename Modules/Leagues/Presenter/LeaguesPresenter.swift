//
//  LeagueListPresenter.swift
//  Sporta
//
//  Created by Hossam on 08/05/2026.
//

import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {
    
    
    // MARK: - Properties
    private weak var view: LeaguesViewProtocol?
    private var leagues: [League] = []
    private var  sport: Sport!
    private let api: ApiManager = ApiManagerImp.shared
    
    var numberOfLeagues: Int {
        leagues.count
    }
    
    init(view: LeaguesViewProtocol, sport: Sport) {
        self.view = view
        self.sport = sport
        fetchData()
    }
    
    func fetchData() {
        if leagues.count == 0 {
            view?.showLoading()
        }
        api.fetchLeagues(for: sport) { [weak self] result in
            
            switch result {
            case .success(let newLeagues) :
                self?.leagues = newLeagues
            case .failure(let error) :
                self?.view?.showError(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self?.view?.reloadData()
                self?.view?.hideLoading()
            }
        }
    }
    
    func getLeague(at index: Int) -> League {
        leagues[index]
    }
}
