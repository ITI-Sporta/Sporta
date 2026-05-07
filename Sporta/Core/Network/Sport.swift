//
//  Sport.swift
//  Sporta
//
//  Created by Hossam on 06/05/2026.
//

import Foundation

enum Sport : String, CaseIterable  {
    case football = "football"
    case basketBall = "basketball"
    case cricket = "cricket"
    case tennis = "tennis"
    
    var displayName: String {
            switch self {
            case .football:   return "Football"
            case .basketBall: return "Basketball"
            case .cricket:    return "Cricket"
            case .tennis:     return "Tennis"
            }
        }
        
        var imageName: String {
            switch self {
            case .football:   return "football_icon"
            case .basketBall: return "basketball_icon"
            case .cricket:    return "cricket_icon"
            case .tennis:     return "tennis_icon"
            }
        }
        
        var sfSymbol: String {
            switch self {
            case .football:   return "soccerball"
            case .basketBall: return "basketball"
            case .cricket:    return "cricket.ball"
            case .tennis:     return "tennis.racket"
            }
        }
}

