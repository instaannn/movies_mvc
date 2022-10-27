// Movies.swift
// Copyright © RoadMap. All rights reserved.

/// Модель фильма
struct Movie: Decodable {
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String
    let id: Int

    private enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case id
    }
}
