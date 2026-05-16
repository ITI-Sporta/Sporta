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
    private var filteredLeagues: [League] = []
    private var sport: Sport!
    private let api: ApiManager = ApiManagerImp.shared
    private var currentQuery: String = ""
    
    var numberOfLeagues: Int {
        filteredLeagues.count
    }
    
    init(view: LeaguesViewProtocol, sport: Sport) {
        self.view = view
        self.sport = sport
        fetchData()
    }
    
    func fetchData() {
        if leagues.isEmpty {
            view?.showLoading()
        }
        api.fetchLeagues(for: sport) { [weak self] result in
            switch result {
            case .success(let newLeagues):
                self?.leagues = newLeagues
                self?.applyCurrentFilter()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self?.view?.reloadData()
                self?.view?.hideLoading()
            }
        }
    }

    func search(query: String) {
        currentQuery = query
        applyCurrentFilter()
        view?.reloadData()
    }

    private func applyCurrentFilter() {
        if currentQuery.trimmingCharacters(in: .whitespaces).isEmpty {
            filteredLeagues = leagues
        } else {
            let lowercased = currentQuery.lowercased()
            filteredLeagues = leagues.filter {
                $0.name.lowercased().contains(lowercased) ||
                ($0.country?.lowercased().contains(lowercased) ?? false)
            }
        }
    }
    func getLeague(at index: Int) -> League {
        filteredLeagues[index]
    }
}
