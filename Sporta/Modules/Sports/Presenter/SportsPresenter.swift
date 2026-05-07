//
//  SportsPresenter.swift
//  Sporta
//
//  Created by Mohamed Ayman on 07/05/2026.
//

import Foundation

class SportsPresenter: SportsPresenterProtocol {
    
    // MARK: - Properties
    private weak var view: SportsViewProtocol?
    private let sports: [Sport] = Sport.allCases
    
    // MARK: - Init
    init(view: SportsViewProtocol) {
        self.view = view
    }
    
    // MARK: - SportsPresenterProtocol
    var numberOfSports: Int {
        sports.count
    }
    
    func sport(at index: Int) -> Sport {
        sports[index]
    }
    
    func didSelectSport(at index: Int) {
        let selected = sports[index]
        view?.navigateToLeagues(with: selected)
    }
}
