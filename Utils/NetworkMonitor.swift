//
//  NetworkMonitor.swift
//  Sporta
//
//  Created by Mohamed Ayman on 13/05/2026.
//

import Foundation
import Alamofire

final class NetworkMonitor {

    static let shared =  NetworkMonitor()

    private let reachability = NetworkReachabilityManager()
    private init() {
    }

    var isConnected: Bool {
        return reachability?.isReachable ?? false
    }
}
