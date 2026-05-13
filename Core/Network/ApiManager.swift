//
//  ApiManager.swift
//  Sporta
//
//  Created by Hossam on 05/05/2026.
//

import Foundation

protocol ApiManager {
    
    func fetchLeagues(for sport: Sport, completion: @escaping (Result<[League], AllSportsError>) -> Void)
    func fetchPastFixtures(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    )
    func fetchUpcomingFixtures(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    )
    func fetchTeams(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[Team], AllSportsError>) -> Void
    )
    func fetchTeamDetailsFixtures(
        for sport: Sport,
        teamId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    )
    func fetchStandings(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<StandingsResult, AllSportsError>) -> Void
    )
    func fetchH2H(
        for sport: Sport,
        firstTeamId: Int,
        secondTeamId: Int,
        completion: @escaping (Result<H2HResult, AllSportsError>) -> Void
    )
    func fetchTeamDetails(
        for sport: Sport,
        teamId: Int,
        completion: @escaping (Result<[TeamDetails], AllSportsError>) -> Void
    )
}


