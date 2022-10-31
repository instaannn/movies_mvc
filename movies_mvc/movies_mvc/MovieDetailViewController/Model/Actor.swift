// Actor.swift
// Copyright © RoadMap. All rights reserved.

/// Модель информации об актере
struct Actor: Decodable {
    let name: String
    let profilePath: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
    }
}
