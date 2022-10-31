// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Вызовы сетевых запросов
final class NetworkService: Core, NetworkServiceProtocol {
    // MARK: - Constants

    private enum Constants {
        static let detailsUrlString = "?api_key=\(Api.token)&language=ru-RU"
        static let trailerUrlString = "/videos?api_key=\(Api.token)"
        static let castUrlString = "/credits?api_key=\(Api.token)"
    }

    // MARK: - Public methods

    func fetchResult(page: Int, requestType: RequestType, complition: @escaping (Result<Movies, Error>) -> Void) {
        downloadJsonResult(page: page, requestType: requestType, complition: complition)
    }

    func fetchDetails(for id: Int, complition: @escaping (Result<MovieDetail, Error>) -> Void) {
        downloadJson(url: "\(Api.detailUrlString)\(id)\(Constants.detailsUrlString)", complition: complition)
    }

    func fetchTrailer(for id: Int, complition: @escaping (Result<Videos, Error>) -> Void) {
        downloadJson(url: "\(Api.detailUrlString)\(id)\(Constants.trailerUrlString)", complition: complition)
    }

    func fetchCast(for id: Int, complition: @escaping (Result<Actors, Error>) -> Void) {
        downloadJson(url: "\(Api.detailUrlString)\(id)\(Constants.castUrlString)", complition: complition)
    }
}
