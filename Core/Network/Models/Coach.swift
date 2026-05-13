//
//  Coach.swift
//  Sporta
//
//  Created by Mohamed Ayman on 10/05/2026.
//

import Foundation

struct Coach: Codable, Identifiable {
    var id: UUID = UUID()

    let name: String?

    enum CodingKeys: String, CodingKey {
        case name = "coach_name"
    }
}
