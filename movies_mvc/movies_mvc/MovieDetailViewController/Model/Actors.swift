// Actors.swift
// Copyright © RoadMap. All rights reserved.

/// Модель списка актеров
struct Actors: Decodable {
    let actors: [Actor]

    private enum CodingKeys: String, CodingKey {
        case actors = "cast"
    }
}
