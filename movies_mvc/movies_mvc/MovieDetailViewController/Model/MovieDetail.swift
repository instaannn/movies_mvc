// MovieDetail.swift
// Copyright © RoadMap. All rights reserved.

/// Модель детального описания фильма
struct MovieDetail: Decodable {
    let backdropPath: String
    let posterPath: String?
    let title: String
    let runtime: Int?
    let voteAverage: Double
    let imdbId: String?
    let releaseDate: String
    let genres: [Genres]
    let overview: String

    private enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case title
        case runtime
        case voteAverage = "vote_average"
        case imdbId = "imdb_id"
        case releaseDate = "release_date"
        case genres
        case overview
    }
}
