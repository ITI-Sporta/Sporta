//
//  ApiManagerMockTests.swift
//  SportaTests
//
//  Created by Mohamed Ayman on 15/05/2026.
//

//
//  ApiManagerMockTests.swift
//  SportaTests
//

import XCTest
import Alamofire
@testable import Sporta

// MARK: - Helpers

private func makeMockSession() -> Session {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return Session(configuration: configuration)
}

private func makeEnvelope(_ result: Any) -> Data {
    let json: [String: Any] = [
        "success": 1,
        "result": result
    ]

    return try! JSONSerialization.data(withJSONObject: json)
}

private func response(_ url: URL, statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(
        url: url,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil
    )!
}

// MARK: - Mock Data

private let leagueJSON: [[String: Any]] = [
    [
        "league_key": 1,
        "league_name": "Premier League",
        "league_logo": ""
    ]
]

private let fixtureJSON: [[String: Any]] = [
    [
        "event_key": 101,
        "event_date": "2024-05-01",
        "event_time": "20:00",
        "event_home_team": "Arsenal",
        "event_away_team": "Chelsea",
        "event_final_result": "2 - 1",
        "league_key": 177
    ]
]

private let teamJSON: [[String: Any]] = [
    [
        "team_key": 4281,
        "team_name": "Arsenal",
        "team_logo": ""
    ]
]


// MARK: - Tests

final class ApiManagerMockTests: XCTestCase {

    private var sut: ApiManagerImp!

    override func setUp() {
        super.setUp()
        sut = ApiManagerImp(session: makeMockSession())
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Leagues

    func test_fetchLeagues_returnsDecodedLeagues() {

        MockURLProtocol.requestHandler = { request in
            (
                response(request.url!),
                makeEnvelope(leagueJSON)
            )
        }

        let exp = expectation(description: "fetch leagues")

        sut.fetchLeagues(for: .football) { result in

            switch result {

            case .success(let leagues):
                XCTAssertEqual(leagues.count, 1)
                XCTAssertEqual(leagues.first?.name, "Premier League")

            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }

            exp.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func test_fetchLeagues_returnsNoDataError_whenResultMissing() {

        MockURLProtocol.requestHandler = { request in

            let body = try! JSONSerialization.data(
                withJSONObject: ["success": 1]
            )

            return (response(request.url!), body)
        }

        let exp = expectation(description: "no data")

        sut.fetchLeagues(for: .football) { result in

            if case .failure(.noData) = result {
                exp.fulfill()
            } else {
                XCTFail("Expected noData")
            }
        }

        waitForExpectations(timeout: 2)
    }

    func test_fetchLeagues_returnsApiError_whenJSONInvalid() {

        MockURLProtocol.requestHandler = { request in
            (
                response(request.url!),
                Data("invalid json".utf8)
            )
        }

        let exp = expectation(description: "invalid json")

        sut.fetchLeagues(for: .football) { result in

            if case .failure(.apiError) = result {
                exp.fulfill()
            } else {
                XCTFail("Expected apiError")
            }
        }

        waitForExpectations(timeout: 2)
    }

    func test_fetchLeagues_requestContainsSport() {

        var capturedRequest: URLRequest?

        MockURLProtocol.requestHandler = { request in
            capturedRequest = request
            return (
                response(request.url!),
                makeEnvelope(leagueJSON)
            )
        }

        let exp = expectation(description: "capture request")

        sut.fetchLeagues(for: .football) { _ in
            exp.fulfill()
        }

        waitForExpectations(timeout: 2)

        XCTAssertTrue(
            capturedRequest?.url?.absoluteString.contains("football") ?? false
        )
    }

    // MARK: - Past Fixtures

    func test_fetchPastFixtures_returnsFixtures() {

        MockURLProtocol.requestHandler = { request in
            (
                response(request.url!),
                makeEnvelope(fixtureJSON)
            )
        }

        let exp = expectation(description: "past fixtures")

        sut.fetchPastFixtures(for: .football, leagueId: 177) { result in

            switch result {

            case .success(let fixtures):
                XCTAssertFalse(fixtures.isEmpty)
                XCTAssertEqual(fixtures.first?.homeTeamName, "Arsenal")

            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }

            exp.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func test_fetchPastFixtures_requestContainsLeagueId() {

        var capturedRequest: URLRequest?

        MockURLProtocol.requestHandler = { request in
            capturedRequest = request

            return (
                response(request.url!),
                makeEnvelope(fixtureJSON)
            )
        }

        let exp = expectation(description: "league id")

        sut.fetchPastFixtures(for: .football, leagueId: 177) { _ in
            exp.fulfill()
        }

        waitForExpectations(timeout: 2)

        let url = capturedRequest?.url?.absoluteString ?? ""

        XCTAssertTrue(url.contains("leagueId=177"))
    }

    func test_fetchPastFixtures_requestContainsTodayDate() {

        var capturedRequest: URLRequest?

        MockURLProtocol.requestHandler = { request in
            capturedRequest = request

            return (
                response(request.url!),
                makeEnvelope(fixtureJSON)
            )
        }

        let exp = expectation(description: "date range")

        sut.fetchPastFixtures(for: .football, leagueId: 177) { _ in
            exp.fulfill()
        }

        waitForExpectations(timeout: 2)

        let today = sut.formatter.string(from: Date())
        let url = capturedRequest?.url?.absoluteString ?? ""

        XCTAssertTrue(url.contains("to=\(today)"))
    }

    // MARK: - Upcoming Fixtures

    func test_fetchUpcomingFixtures_returnsFixtures() {

        MockURLProtocol.requestHandler = { request in
            (
                response(request.url!),
                makeEnvelope(fixtureJSON)
            )
        }

        let exp = expectation(description: "upcoming fixtures")

        sut.fetchUpcomingFixtures(for: .football, leagueId: 177) { result in

            switch result {

            case .success(let fixtures):
                XCTAssertFalse(fixtures.isEmpty)

            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }

            exp.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    // MARK: - Teams

    func test_fetchTeams_returnsDecodedTeams() {

        MockURLProtocol.requestHandler = { request in
            (
                response(request.url!),
                makeEnvelope(teamJSON)
            )
        }

        let exp = expectation(description: "teams")

        sut.fetchTeams(for: .football, leagueId: 177) { result in

            switch result {

            case .success(let teams):
                XCTAssertEqual(teams.first?.name, "Arsenal")

            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }

            exp.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    // MARK: - Team Details

    func test_fetchTeamDetails_returnsDecodedTeamDetails() {

        MockURLProtocol.requestHandler = { request in
            (
                response(request.url!),
                makeEnvelope(teamJSON)
            )
        }

        let exp = expectation(description: "team details")

        sut.fetchTeamDetails(for: .football, teamId: 4281) { result in

            switch result {

            case .success(let details):
                XCTAssertEqual(details.first?.name, "Arsenal")

            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }

            exp.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
    
    func test_fetchTeamDetailsFixtures_usesThreeMonthDateRange() {

        var capturedRequest: URLRequest?

        MockURLProtocol.requestHandler = { request in
            capturedRequest = request

            return (
                response(request.url!),
                makeEnvelope(fixtureJSON)
            )
        }

        let exp = expectation(description: "date range")

        sut.fetchTeamDetailsFixtures(for: .football, teamId: 4281) { _ in
            exp.fulfill()
        }

        waitForExpectations(timeout: 2)

        let url = capturedRequest?.url?.absoluteString ?? ""

        let today = Date()

        let expectedPast =
            sut.formatter.string(
                from: Calendar.current.date(
                    byAdding: .month,
                    value: -3,
                    to: today
                )!
            )

        let expectedFuture =
            sut.formatter.string(
                from: Calendar.current.date(
                    byAdding: .month,
                    value: 3,
                    to: today
                )!
            )

        XCTAssertTrue(url.contains("from=\(expectedPast)"))
        XCTAssertTrue(url.contains("to=\(expectedFuture)"))
    }
}
