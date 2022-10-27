// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Сетевой слой
final class NetworkService: NetworkServiceProtocol {
    // MARK: - Constants

    private enum Constants {
        static let detailsUrlString = "?api_key=\(Url.token)&language=ru-RU"
        static let trailerUrlString = "/videos?api_key=\(Url.token)"
        static let castUrlString = "/credits?api_key=\(Url.token)"
    }

    // MARK: - Public methods

    func fetchResult(page: Int, requestType: RequestType, complition: @escaping (Result<Results, Error>) -> Void) {
        downloadJsonResult(page: page, requestType: requestType, complition: complition)
    }

    func fetchDetails(for id: Int, complition: @escaping (Result<MovieDetail, Error>) -> Void) {
        downloadJson(url: "\(Url.urlDetail)\(id)\(Constants.detailsUrlString)", complition: complition)
    }

    func fetchTrailer(for id: Int, complition: @escaping (Result<Trailers, Error>) -> Void) {
        downloadJson(url: "\(Url.urlDetail)\(id)\(Constants.trailerUrlString)", complition: complition)
    }

    func fetchCast(for id: Int, complition: @escaping (Result<Cast, Error>) -> Void) {
        downloadJson(url: "\(Url.urlDetail)\(id)\(Constants.castUrlString)", complition: complition)
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

    private func downloadJsonResult<T: Decodable>(
        page: Int,
        requestType: RequestType,
        complition: @escaping (Result<T, Error>) -> Void
    ) {
        var queryItems = [URLQueryItem(name: "api_key", value: Url.token)]
        queryItems.append(URLQueryItem(name: "language", value: "ru-RU"))
        queryItems.append(URLQueryItem(name: "page", value: "\(page)"))

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = requestType.rawValue
        components.queryItems = queryItems

        guard let url = components.url else { return }

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
