//
//  LeagueContract.swift
//  Sporta
//
//  Created by Hossam on 08/05/2026.
//

import Foundation

protocol LeaguesPresenterProtocol {
    var numberOfLeagues: Int { get }
    func fetchData()
    func search(query: String)
    func getLeague(at index: Int) -> League
}

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(_ message: String)
}
