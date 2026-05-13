//
//  Contract.swift
//  Sporta
//
//  Created by Hossam on 13/05/2026.
//

import Foundation

protocol TeamDetailsPresenterProtocol {
    func getTeamDetails() -> TeamDetails?
    func getPlayersCount() -> Int
    func getFixturesCount() -> Int
    func getPlayer(at index: Int) -> Player
    func getFixture(at index: Int) -> Fixture
    func fetchData(sport: Sport, teamId: Int)
}

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
}
