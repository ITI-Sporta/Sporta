//
//  LeagueDetailsContract.swift
//  Sporta
//
//  Created by Mohamed Ayman on 08/05/2026.
//

import Foundation

// MARK: - Presenter Protocol (View → Presenter)
protocol LeagueDetailsPresenterProtocol: AnyObject {
    var upcomingFixtures: [Fixture] { get }
    var pastFixtures:     [Fixture] { get }
    var liveFixtures:     [Fixture] { get }
    
    func viewDidLoad()
    func didChangeSegment(to index: Int)
    func numberOfRows(for segmentIndex: Int) -> Int
    func fixture(at index: Int, for segmentIndex: Int) -> Fixture
}

// MARK: - View Protocol (Presenter → View)
protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadFixtures()
    func showError(message: String)
}
