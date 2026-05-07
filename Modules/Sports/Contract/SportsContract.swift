//
//  SportsContract.swift
//  Sporta
//
//  Created by Mohamed Ayman on 07/05/2026.
//

import Foundation

protocol SportsPresenterProtocol: AnyObject {
    var numberOfSports: Int { get }
    func sport(at index: Int) -> Sport
    func didSelectSport(at index: Int)
}

protocol SportsViewProtocol: AnyObject {
    func navigateToLeagues(with sport: Sport)
}
