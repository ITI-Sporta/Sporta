//
//  Fixture.swift
//  Sporta
//
//  Created by Hossam on 06/05/2026.
//

import Foundation


struct Fixture: Codable, Identifiable {
    let id: Int
    let date: String?
    let time: String?
    let status: String?
    let homeTeamName: String?
    let awayTeamName: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let homeScore: String?
    let leagueName: String?
    let leagueRound: String?

    enum CodingKeys: String, CodingKey {
        case id = "event_key"
        case date = "event_date"
        case time = "event_time"
        case status = "event_status"
        case homeTeamName = "event_home_team"
        case awayTeamName = "event_away_team"
        case homeTeamLogo = "event_home_team_logo"
        case awayTeamLogo = "event_away_team_logo"
        case homeScore = "event_final_result"
        case leagueName = "league_name"
        case leagueRound = "league_round"
    }

    var scoreParts: (home: String, away: String)? {
        guard let raw = homeScore else { return nil }
        let parts = raw.components(separatedBy: " - ")
        guard parts.count == 2 else { return nil }
        return (parts[0], parts[1])
    }

    var isFinished: Bool { status == "Finished" }
    var isLive: Bool { status == "1H" || status == "2H" || status == "HT" }
}
