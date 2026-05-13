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
/// team details: https://apiv2.allsportsapi.com/football/?met=Teams&teamId=4281&APIkey=
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
    private let apiKey = "6df31c83e2c56ac113d2bfa2a59abeba5df8b7cb535052dd98aac0ec47379f7d"
    
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
            .responseData { response in
                print("ApiManager: got response!")
                switch response.result {
                case .success(let rawData):
                    do {
                        let apiResponse = try JSONDecoder().decode(AllSportsResponse<T>.self, from: rawData)
                        if let result = apiResponse.result {
                            completion(.success(result))
                        } else {
                            completion(.failure(.noData))
                        }
                    } catch {
                        completion(.failure(.apiError(error.localizedDescription)))
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
        let pastTwoWeeks = Calendar.current.date(byAdding: .day, value: -14, to: today)!
        
        let from = formatter.string(from: pastTwoWeeks)
        let to = formatter.string(from: today)
        
        fetchFixtures(for: sport, leagueId:leagueId,from:from,to:to ,completion:completion)
    }
    
    func fetchUpcomingFixtures(
        for sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let today = Date()
        let nextTwoWeeks = Calendar.current.date(byAdding: .day, value: 14, to: today)!
        
        let from = formatter.string(from: today)
        let to = formatter.string(from: nextTwoWeeks)
        
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
    
    func fetchTeamDetailsFixtures(
        for sport: Sport,
        teamId: Int,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let today = Date()
        let nextTwoWeeks = Calendar.current.date(byAdding: .day, value: 14, to: today)!
        let pastTwoWeeks = Calendar.current.date(byAdding: .day, value: -14, to: today)!
        
        let from = formatter.string(from: pastTwoWeeks)
        let to = formatter.string(from: nextTwoWeeks)
        
        fetchTeamFixtures(for: sport, teamId: teamId, from: from, to: to, completion: completion)
    }
    
    private func fetchTeamFixtures(
        for sport: Sport,
        teamId: Int,
        from: String,
        to: String,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        let params: [String: String] = [
            "met": "Fixtures",
            "teamId": String(teamId),
            "from": from,
            "to": to
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

    func fetchTeamDetails(
        for sport: Sport,
        teamId: Int,
        completion: @escaping (Result<[TeamDetails], AllSportsError>) -> Void
    ) {
        let params: [String: String] = [
            "met": "Teams",
            "teamId": String(teamId)
        ]

        fetch(sport, params: params, completion: completion)
    }
}
