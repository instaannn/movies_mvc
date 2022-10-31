// Core.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Сетевые запросы
class Core {
    // MARK: - Public methods

    func downloadJson<T: Decodable>(url: String, complition: @escaping (Result<T, Error>) -> Void) {
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

    func downloadJsonResult<T: Decodable>(
        page: Int,
        requestType: RequestType,
        complition: @escaping (Result<T, Error>) -> Void
    ) {
        var queryItems = [URLQueryItem(name: "api_key", value: Api.token)]
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
