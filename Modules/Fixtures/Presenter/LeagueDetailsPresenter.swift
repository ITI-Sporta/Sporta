//
//  LeagueDetailsPresenter.swift
//  Sporta
//
//  Created by Mohamed Ayman on 08/05/2026.
//

import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    
    // MARK: - Properties
    private weak var view: LeagueDetailsViewProtocol?
    private let apiManager: ApiManager
    private let leagueId: Int
    private let sport: Sport
    private let db: DatabaseProtocol
    
    private(set) var upcomingFixtures: [Fixture] = []
    private(set) var pastFixtures:     [Fixture] = []
    private(set) var liveFixtures:     [Fixture] = []
    private(set) var teams:            [Team]    = []
    
    // MARK: - Init
    init(
        view: LeagueDetailsViewProtocol,
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
    
    // MARK: - LeagueDetailsPresenterProtocol
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
    
    func checkIsFavorite(id: Int) {
        let isFavorite = db.isFavoriteLeague(id: id)
        if isFavorite {
            view?.setFavoriteIcon(systemName: "heart.fill")
        } else {
            view?.setFavoriteIcon(systemName: "heart")
        }
    }
    
    func toggleIsFavorite(league: League) {
        let isFavorite = db.isFavoriteLeague(id: league.id)
        if isFavorite {
            let success = db.deleteFavoriteLeague(by: league.id)
            if success {
                view?.setFavoriteIcon(systemName: "heart")
                view?.showToast(type: .info, message: "Deleted \(league.name) from favorites")
            } else {
                view?.showToast(type: .error, message: "Unable to delete \(league.name) from favorites")
            }
        } else {
            let success = db.addFavoriteLeague(league.toFavorite(sport))
            if success {
                view?.setFavoriteIcon(systemName: "heart.fill")
                view?.showToast(type: .success, message: "Added \(league.name) to favorites")
            } else {
                view?.showToast(type: .error, message: "Unable to add \(league.name) to favorites")
            }
            
            
        }
    }
    
    func getTeamId(teamName: String) -> Int {
        return teams.first(where: { $0.name == teamName })?.id ?? 0
    }
}

extension League {
    func toFavorite(_ sport: Sport) -> FavoriteLeague {
        FavoriteLeague(id: id, name: name, country: country ?? "", logo: logo ?? "", countryLogo: countryLogo ?? "", sport: sport)
    }
}
