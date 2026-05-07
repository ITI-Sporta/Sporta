//
//  ApiManagerImp.swift
//  Sporta
//
//  Created by Hossam on 06/05/2026.
//

import Foundation
import Alamofire


/// Used endpoints
///leagues: https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=b7
///latest + upcoming: change from / to
///https://apiv2.allsportsapi.com/basketball/?met=Fixtures&from=2026-05-06&to=2027-01-01&leagueId=757&APIkey=
/// all teams: https://apiv2.allsportsapi.com/football/?met=Teams&leagueId=177&APIkey=
/// team details:
///upcoming + past: change from / to https://apiv2.allsportsapi.com/basketball/?met=Fixtures&teamId=144&from=2026-05-06&to=2027-01-01&leagueId=757&APIkey=b7
///league standing: https://apiv2.allsportsapi.com/football/?met=Standings&leagueId=177&APIkey=b7
///head to head: https://apiv2.allsportsapi.com/football/?met=H2H&firstTeamId=177&secondTeamId=80&APIkey=b7

class ApiManagerImp: ApiManager {
    
    static let shared = ApiManagerImp()
    let formatter = DateFormatter()
    
    private init() {
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    private let baseUrl = "https://apiv2.allsportsapi.com"
    private let apiKey = "b7d6c34fb6480d3f705747f613315af7460de66a566e37ad50ebb80bbc1e9af9"
    
    private func fetch<T: Codable>(
        _ sport: Sport,
        params: [String: String],
        completion: @escaping (Result<T, AllSportsError>) -> Void
    ) {
        let url = "\(baseUrl)/\(sport.rawValue)/"
        var parameters: [String: String] = ["APIkey": apiKey]
        parameters.merge(params) { _, new in new }

        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: AllSportsResponse<T>.self) { response in
                print("ApiManager: recieved response!")
                switch response.result {
                case .success(let apiResponse):
                    if let result = apiResponse.result {
                        completion(.success(result))
                    } else {
                        completion(.failure(.noData))
                    }
                case .failure(let afError):
                    if let data = response.data,
                       let msg = try? JSONDecoder().decode(APIErrorBody.self, from: data) {
                        completion(.failure(.apiError(msg.firstMessage ?? afError.localizedDescription)))
                    } else {
                        completion(.failure(.apiError(afError.localizedDescription)))
                    }
                }
            }
    }
    
    func fetchLeagues(for sport: Sport, completion: @escaping (Result<[League], AllSportsError>) -> Void) {
        fetch(sport, params: ["met": "Leagues"], completion: completion)
    }
    
    func fetchPastFixtures(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let today = Date()
        let pastYear = Calendar.current.date(byAdding: .year, value: -1, to: today)!
        
        let from = formatter.string(from: pastYear)
        let to = formatter.string(from: today)
        
        fetchFixtures(for: sport, leagueId:leagueId,from:from,to:to ,completion:completion)
    }
    
    func fetchUpcomingFixtures(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let today = Date()
        let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        
        let from = formatter.string(from: today)
        let to = formatter.string(from: nextYear)
        
        fetchFixtures(for: sport, leagueId: leagueId, from: from, to: to, completion: completion)
    }
    
    private func fetchFixtures(
        for sport: Sport,
        leagueId: Int,
        from: String,
        to: String,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let params: [String: String] = [
            "met":      "Fixtures",
            "leagueId": String(leagueId),
            "from":     from,
            "to":       to
        ]
        fetch(sport, params: params, completion: completion)
    }
    
    func fetchTeams(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[Team], AllSportsError>) -> Void
    ) {
        let params: [String: String] = [
            "met":      "Teams",
            "leagueId": String(leagueId)
        ]
        fetch(sport, params: params, completion: completion)
    }
    
    func fetchPastTeamFixtures(
        for sport: Sport,
        teamId: Int,
        leagueId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let today = Date()
        let pastYear = Calendar.current.date(byAdding: .year, value: -1, to: today)!
        
        let from = formatter.string(from: pastYear)
        let to = formatter.string(from: today)
        
        fetchTeamFixtures(for: sport, teamId: teamId, leagueId: leagueId, from: from, to: to, completion: completion)
    }
    
    func fetchUpcomingTeamFixtures(
        for sport: Sport,
        teamId: Int,
        leagueId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let today = Date()
        let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        
        let from = formatter.string(from: today)
        let to = formatter.string(from: nextYear)
        
        fetchTeamFixtures(for: sport, teamId: teamId, leagueId: leagueId, from: from, to: to, completion: completion)
    }
    
    private func fetchTeamFixtures(
        for sport: Sport,
        teamId: Int,
        leagueId: Int,
        from: String,
        to: String,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let params: [String: String] = [
            "met":      "Fixtures",
            "teamId":   String(teamId),
            "leagueId": String(leagueId),
            "from":     from,
            "to":       to
        ]
        fetch(sport, params: params, completion: completion)
    }
    
    func fetchStandings(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<StandingsResult, AllSportsError>) -> Void
    ) {
        let params: [String: String] = [
            "met":      "Standings",
            "leagueId": String(leagueId)
        ]
        fetch(sport, params: params, completion: completion)
    }
    
    func fetchH2H(
        for sport: Sport,
        firstTeamId: Int,
        secondTeamId: Int,
        completion: @escaping (Result<H2HResult, AllSportsError>) -> Void
    ) {
        let params: [String: String] = [
            "met":          "H2H",
            "firstTeamId":  String(firstTeamId),
            "secondTeamId": String(secondTeamId)
        ]
        fetch(sport, params: params, completion: completion)
    }
}

/*  for testing
 let api = ApiManagerImp.shared
 
 api.fetchLeagues(for: .football) { result in
     switch result {
     case .success(let leagues):
         api.fetchStandings(for: .football, leagueId: leagues[0].id) { result in
             print("fetchStandings")
             switch result {
             case .success(let standings):
                 print(standings.total?[0].teamName ?? "No Name")
                 
             case .failure(let failedRes) :
                 print(failedRes.errorDescription ?? "error")
             }
         }
         api.fetchUpcomingFixtures(for: .football, leagueId: leagues[0].id) { result in
             print("fetchUpcomingFixtures")
             switch result {
             case .success(let fixtures):
                 print(fixtures[0].awayTeamName ?? "no team name")
                 
             case .failure(let failedRes) :
                 print(failedRes.errorDescription ?? "error")
             }
         }
         api.fetchTeams(for: .football, leagueId: leagues[0].id) { result in
             print("fetchTeams")
             switch result {
             case .success(let teams) :
                 api.fetchH2H(for: .football, firstTeamId: teams[0].id, secondTeamId: teams[1].id) { result2 in
                     print("fetchh2h")
                     switch result2 {
                     case .success(let h2h):
                         print(h2h.h2hResults?[0].awayTeamName ?? "No Name")
                     case .failure(let failRes):
                         print(failRes.errorDescription ?? "error")
                     }
                 }
                 api.fetchUpcomingTeamFixtures(for: .football, teamId: teams[0].id, leagueId: leagues[0].id) { result in
                     switch result {
                     case .success(let fixtures):
                         print(fixtures[0].awayTeamName ?? "no team name")
                         
                     case .failure(let failedRes) :
                         print(failedRes.errorDescription ?? "error")
                     }
                 }
             case .failure(let failedRes):
                 print(failedRes.errorDescription ?? "error")
             }
         }
     case .failure(let response):
         print(response.errorDescription ?? "error")
     }
 }
 */
