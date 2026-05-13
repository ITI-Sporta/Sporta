//
//  FakeApiManager.swift
//  SportaTests
//
//  Created by Hossam on 13/05/2026.
//

import Foundation
@testable import Sporta

class FakeApiManager: ApiManager {
    
    func fetchLeagues(for sport: Sport, completion: @escaping (Result<[League], AllSportsError>) -> Void) {
        completion(.success([
            League(id: 0, name: "Nile", country: "Egypt", logo: "", countryLogo: ""),
            League(id: 1, name: "LA LIGA", country: "Spain", logo: "", countryLogo: ""),
            League(id: 2, name: "Premium", country: "England", logo: "", countryLogo: ""),
        ]))
    }
    
    func fetchPastFixtures(for sport: Sport, leagueId: Int, completion: @escaping (Result<[Fixture], AllSportsError>) -> Void) {
        completion(.success([
            Fixture(id: 0, date: "2026-3-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 1"),
            Fixture(id: 1, date: "2026-4-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 2"),
            Fixture(id: 2, date: "2026-5-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 3"),
        ]))
    }
    
    func fetchUpcomingFixtures(for sport: Sport, leagueId: Int, completion: @escaping (Result<[Fixture], AllSportsError>) -> Void) {
        completion(.success([
            Fixture(id: 0, date: "2026-3-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 1"),
            Fixture(id: 1, date: "2026-4-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 2"),
            Fixture(id: 2, date: "2026-5-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 3"),
        ]))
    }
    
    func fetchTeams(for sport: Sport, leagueId: Int, completion: @escaping (Result<[Team], AllSportsError>) -> Void) {
        completion(.success([
            Team(id: 0, name: "Al Ahly", logo: ""),
            Team(id: 1, name: "Zamalek", logo: ""),
            Team(id: 2, name: "Liverpool", logo: ""),
        ]))
    }
    
    func fetchTeamDetailsFixtures(for sport: Sport, teamId: Int, completion: @escaping (Result<[Fixture], AllSportsError>) -> Void) {
        completion(.success([
            Fixture(id: 0, date: "2026-3-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 1"),
            Fixture(id: 1, date: "2026-4-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 2"),
            Fixture(id: 2, date: "2026-5-10", time: "10:00 pm", status: "Finished", homeTeamName: "Al Ahly", awayTeamName: "Zamalek", homeTeamLogo: "", awayTeamLogo: "", eventHomeTeamLogo: "", eventAwayTeamLogo: "", homeScore: "2 - 1", leagueName: "Nile", leagueRound: "Round 3"),
        ]))
    }
    
    func fetchTeamDetails(for sport: Sport, teamId: Int, completion: @escaping (Result<[TeamDetails], AllSportsError>) -> Void) {
        completion(.success([
            TeamDetails(id: 1,
                        name: "Real Madrid",
                        logo: "",
                        players: [
                            Player(name: "Mohamed Salah", image: "", number: "10", type: "Forward", age: "24"),
                            Player(name: "Buffon", image: "", number: "1", type: "Goalkeeper", age: "30"),
                            Player(name: "Marcelo", image: "", number: "3", type: "Defender", age: "27"),
                        ],
                        coaches: [Coach(name: "Zedan")])
        ]))
    }

}
