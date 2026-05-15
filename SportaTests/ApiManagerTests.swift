//
//  SportaTests.swift
//  SportaTests
//
//  Created by Hossam on 04/05/2026.
//

import XCTest
@testable import Sporta

class ApiManagerTests: XCTestCase {

    var apiManager : ApiManager!
    
    override func setUp() {
        apiManager = ApiManagerImp.shared
    }
    
    override func tearDown() {
        apiManager = nil
    }

    func test_fetch_leagues_returns_data() {
        let exp = expectation(description: "leagues")
        apiManager.fetchLeagues(for: .football) { result in
            switch result {
            case .success(let leagues):
                XCTAssertFalse(leagues.isEmpty)
                exp.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 10)
    }

    func test_fetch_past_fixtures_returns_data() {
        let exp = expectation(description: "past Fixtures")
        apiManager.fetchPastFixtures(for: .football, leagueId: 177) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertFalse(fixtures.isEmpty)
                exp.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_fetch_upcoming_fixtures_returns_data() {
        let exp = expectation(description: "Upcoming Fixtures")
        apiManager.fetchUpcomingFixtures(for: .football, leagueId: 177) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertFalse(fixtures.isEmpty)
                exp.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_fetch_teams_returns_data() {
        let exp = expectation(description: "teams")
        apiManager.fetchTeams(for: .football, leagueId: 177) { result in
            switch result {
            case .success(let teams):
                XCTAssertFalse(teams.isEmpty)
                exp.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_fetch_team_fixtures_returns_data() {
        let exp = expectation(description: "team details fixtures")
        apiManager.fetchTeamDetailsFixtures(for: .football, teamId: 4281) { result in
            switch result {
            case .success(let teamFixtures):
                XCTAssertFalse(teamFixtures.isEmpty)
                exp.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_fetch_team_details_returns_data() {
        let exp = expectation(description: "team details")
        apiManager.fetchTeamDetails(for: .football, teamId: 4281) { result in
            switch result {
            case .success(let teamDetails):
                XCTAssertFalse(teamDetails.isEmpty)
                exp.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 10)
    }
}
