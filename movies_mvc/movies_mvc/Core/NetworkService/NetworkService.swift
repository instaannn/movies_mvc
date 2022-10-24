// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Сетевой слой
final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Public methods

    func fetchPopularResult(complition: @escaping (Result<Results, Error>) -> Void) {
        downloadJson(url: Url.urlPopular, complition: complition)
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
