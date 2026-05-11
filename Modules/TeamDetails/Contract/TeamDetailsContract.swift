//
//  TeamDetailsContract.swift
//  Sporta
//
//  Created by Hossam on 11/05/2026.
//

import Foundation

protocol TeamDetailsPresenterProtocol: AnyObject {
    var upcomingFixtures: [Fixture] { get }
    var pastFixtures:     [Fixture] { get }
    var liveFixtures:     [Fixture] { get }
    var teams:            [Team]    { get }
    
    func viewDidLoad()
    func didChangeSegment(to index: Int)
    func numberOfRows(for segmentIndex: Int) -> Int
    func fixture(at index: Int, for segmentIndex: Int) -> Fixture
    func numberOfTeams() -> Int
    func team(at index: Int) -> Team
}

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadFixtures()
    func reloadTeams()
    func showError(message: String)
}
