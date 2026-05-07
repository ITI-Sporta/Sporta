//
//  H2HResult.swift
//  Sporta
//
//  Created by Hossam on 06/05/2026.
//

import Foundation


struct H2HResult: Codable {
    let h2hResults: [Fixture]?

    enum CodingKeys: String, CodingKey {
        case h2hResults = "H2H"
    }
}
