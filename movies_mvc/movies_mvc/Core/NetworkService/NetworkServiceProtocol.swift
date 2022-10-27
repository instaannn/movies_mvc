// NetworkServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

/// Протокол для сетевого слоя
protocol NetworkServiceProtocol {
    func fetchDetails(for id: Int, complition: @escaping (Result<MovieDetail, Error>) -> Void)
    func fetchTrailer(for id: Int, complition: @escaping (Result<Trailers, Error>) -> Void)
    func fetchCast(for id: Int, complition: @escaping (Result<Cast, Error>) -> Void)
    func fetchResult(page: Int, requestType: RequestType, complition: @escaping (Result<Results, Error>) -> Void)
}
