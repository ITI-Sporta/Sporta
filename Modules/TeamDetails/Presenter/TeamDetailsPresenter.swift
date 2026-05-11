//
//  TeamDetailsPresenter.swift
//  Sporta
//
//  Created by Hossam on 11/05/2026.
//

import Foundation


class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    

    private weak var view: TeamDetailsViewProtocol?
    private let apiManager: ApiManager
    private let leagueId: Int
    private let sport: Sport
    private let db: DatabaseProtocol
    
    private(set) var upcomingFixtures: [Fixture] = []
    private(set) var pastFixtures:     [Fixture] = []
    private(set) var liveFixtures:     [Fixture] = []
    private(set) var teams:            [Team]    = []
    

    init(
        view: TeamDetailsViewProtocol,
        apiManager: ApiManager = ApiManagerImp.shared,
        db: DatabaseProtocol = CoreDataManager.shared,
        leagueId: Int,
        sport: Sport
    ) {
        self.view       = view
        self.apiManager = apiManager
        self.leagueId   = leagueId
        self.sport      = sport
        self.db         = db
    }
    

    func viewDidLoad() {
        fetchAll()
    }
    
    func didChangeSegment(to index: Int) {
        view?.reloadFixtures()
    }
    
    func numberOfRows(for segmentIndex: Int) -> Int {
        switch segmentIndex {
        case 0: return upcomingFixtures.count
        case 1: return pastFixtures.count
        case 2: return liveFixtures.count
        default: return 0
        }
    }
    
    func fixture(at index: Int, for segmentIndex: Int) -> Fixture {
        switch segmentIndex {
        case 0: return upcomingFixtures[index]
        case 1: return pastFixtures[index]
        case 2: return liveFixtures[index]
        default: fatalError("Invalid segment index")
        }
    }
    
    func numberOfTeams() -> Int {
        teams.count
    }
    
    func team(at index: Int) -> Team {
        teams[index]
    }
    
    private func fetchAll() {
        view?.showLoading()
        
        let group = DispatchGroup()
        var fetchError: AllSportsError?
        
        group.enter()
        apiManager.fetchUpcomingFixtures(for: sport, leagueId: leagueId) { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let fixtures):
                self?.upcomingFixtures = fixtures.filter { !$0.isLive }
                self?.liveFixtures     = fixtures.filter { $0.isLive }
            case .failure(let error):
                fetchError = error
            }
        }
        
        group.enter()
        apiManager.fetchPastFixtures(for: sport, leagueId: leagueId) { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let fixtures):
                self?.pastFixtures = fixtures.filter { $0.isFinished }
            case .failure(let error):
                fetchError = error
            }
        }
        
        group.enter()
        apiManager.fetchTeams(for: sport, leagueId: leagueId) { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let teams):
                self?.teams = teams
            case .failure(let error):
                fetchError = error
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.hideLoading()
            if let error = fetchError {
                self?.view?.showError(message: error.localizedDescription)
            } else {
                self?.view?.reloadFixtures()
                self?.view?.reloadTeams()
            }
        }
    }
}
