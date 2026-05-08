//
//  SportsContract.swift
//  Sporta
//
//  Created by Mohamed Ayman on 07/05/2026.
//

import Foundation

// MARK: - Presenter Protocol (View → Presenter)
protocol SportsPresenterProtocol: AnyObject {
    var numberOfSports: Int { get }
    func sport(at index: Int) -> Sport
    func didSelectSport(at index: Int)
}

// MARK: - View Protocol (Presenter → View)
protocol SportsViewProtocol: AnyObject {
    func navigateToLeagues(with sport: Sport)
}
