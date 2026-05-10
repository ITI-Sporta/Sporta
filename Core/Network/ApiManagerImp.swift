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
            .responseData { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let rawData):
                    let data = self.normalizeFixtureLogoKeys(in: rawData)
                    do {
                        let apiResponse = try JSONDecoder().decode(AllSportsResponse<T>.self, from: data)
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
        leagueId: Int? = nil,
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
        leagueId: Int? = nil,
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
        leagueId: Int? = nil,
        from: String,
        to: String,
        completion: @escaping (Result<[Fixture], AllSportsError>) -> Void
    ) {
        var params: [String: String] = [
            "met": "Fixtures",
            "teamId": String(teamId),
            "from": from,
            "to": to
        ]

        if let leagueId {
            params["leagueId"] = String(leagueId)
        }
        
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

extension ApiManagerImp {
    func normalizeFixtureLogoKeys(in data: Data) -> Data {
        guard var response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let fixtures = response["result"] as? [[String: Any]] else { return data }
        
        response["result"] = fixtures.map { fixture in
            var normalized = fixture
            if let homeLogo = fixture["event_home_team_logo"] { normalized["home_team_logo"] = homeLogo }
            if let awayLogo = fixture["event_away_team_logo"] { normalized["away_team_logo"] = awayLogo }
            return normalized
        }
        
        return (try? JSONSerialization.data(withJSONObject: response)) ?? data
    }
}
