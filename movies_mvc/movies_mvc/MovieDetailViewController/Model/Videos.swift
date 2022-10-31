// Videos.swift
// Copyright © RoadMap. All rights reserved.

/// Модель трейлеров
struct Videos: Decodable {
    let videos: [Video]

    private enum CodingKeys: String, CodingKey {
        case videos = "results"
    }
}
