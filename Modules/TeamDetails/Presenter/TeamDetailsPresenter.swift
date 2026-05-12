//
//  TeamDetailsPresenter.swift
//  Sporta
//
//  Created by Hossam on 12/05/2026.
//

import Foundation



class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    
    weak var view: TeamDetailsViewProtocol?
    let apiManager: ApiManager
    
    var teamDetails: TeamDetails?
    var fixtures: [Fixture] = []
    
    init(view: TeamDetailsViewProtocol,
         apiManager: ApiManager = ApiManagerImp.shared) {
        self.view = view
        self.apiManager = apiManager
    }
    
    func getTeamDetails() -> TeamDetails? {
        teamDetails
    }
    
    func getPlayersCount() -> Int {
        teamDetails?.players?.count ?? 0
    }

    func getFixturesCount() -> Int {
        fixtures.count
    }
    
    func getPlayer(at index: Int) -> Player{
        teamDetails?.players?[index] ?? Player.getEmptyPlayrt()
    }
    
    func getFixture(at index: Int) -> Fixture {
        fixtures[index]
    }
    
    func fetchData(sport: Sport, teamId: Int) {
        view?.showLoading()
        
        let group = DispatchGroup()
        var fetchError: AllSportsError?
        
        group.enter()
        apiManager.fetchTeamDetails(for: sport, teamId: teamId) { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let teamDetails):
                guard teamDetails.count > 0 else {
                    fetchError = AllSportsError.noData
                    return
                }
                self?.teamDetails = teamDetails.first
            case .failure(let error):
                fetchError = error
            }
        }
        
        group.enter()
        apiManager.fetchTeamDetailsFixtures(for: sport, teamId: teamId) { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let fixtures):
                self?.fixtures = fixtures
            case .failure(let error):
                fetchError = error
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.hideLoading()
            if let error = fetchError {
                self?.view?.showError(message: error.errorDescription ?? "Error happened")
            } else {
                self?.view?.reloadData()
            }
        }
    }
}
