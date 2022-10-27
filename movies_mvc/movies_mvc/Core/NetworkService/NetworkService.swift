// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Сетевой слой
final class NetworkService: NetworkServiceProtocol {
    // MARK: - Public methods

    func fetchPopularResult(complition: @escaping (Result<Results, Error>) -> Void) {
        downloadJson(url: Url.urlPopular, complition: complition)
    }

    func fetchTopRatedResult(complition: @escaping (Result<Results, Error>) -> Void) {
        downloadJson(url: Url.urlTopRated, complition: complition)
    }

    func fetchUpcomingResult(complition: @escaping (Result<Results, Error>) -> Void) {
        downloadJson(url: Url.urlUpcoming, complition: complition)
    }

    func fetchDetails(for id: Int, complition: @escaping (Result<MovieDetail, Error>) -> Void) {
        downloadJson(url: "\(Url.urlDetail)\(id)?api_key=\(Url.token)&language=ru-RU", complition: complition)
    }

    func fetchTrailer(for id: Int, complition: @escaping (Result<Trailers, Error>) -> Void) {
        downloadJson(url: "\(Url.urlDetail)\(id)/videos?api_key=\(Url.token)", complition: complition)
    }

    func fetchCast(for id: Int, complition: @escaping (Result<Cast, Error>) -> Void) {
        downloadJson(url: "\(Url.urlDetail)\(id)/credits?api_key=\(Url.token)", complition: complition)
    }

    // MARK: - Private methods

    private func downloadJson<T: Decodable>(url: String, complition: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { return }

        let session = URLSession.shared
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            guard let data = data else { return }

            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                complition(.success(object))
            } catch {
                complition(.failure(error))
            }
        }.resume()
    }
}
