// NetworkServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

/// Протокол для сетевого слоя
protocol NetworkServiceProtocol {
    func fetchPopularResult(complition: @escaping (Result<Results, Error>) -> Void)
    func fetchTopRatedResult(complition: @escaping (Result<Results, Error>) -> Void)
    func fetchUpcomingResult(complition: @escaping (Result<Results, Error>) -> Void)
}
