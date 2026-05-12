//
//  TeamDetailsPresenter.swift
//  Sporta
//
//  Created by Hossam on 12/05/2026.
//

import Foundation

protocol TeamDetailsPresenterProtocol {
    func getTeamDetails() -> TeamDetails?
    func getPlayersCount() -> Int
    func getFixturesCount() -> Int
    func getPlayer(at index: Int) -> Player
    func getFixture(at index: Int) -> Fixture
}

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    
    weak var view: TeamDetailsViewProtocol?
    
    var teamDetails: TeamDetails?
    var fixtures: [Fixture] = []
    
    init(view: TeamDetailsViewProtocol) {
        self.view = view
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
}
