// Movies.swift
// Copyright © RoadMap. All rights reserved.

/// Модель списка фильмов
struct Movies: Decodable {
    let movies: [Movie]

    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
