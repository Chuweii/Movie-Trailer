//
//  MovieDBRepository.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/20.
//

import Foundation
import Moya

protocol MovieDBRepositoryProtocol {
    func getTrendingMovies() async throws -> [Movie]
    func getTrendingTV() async throws -> [Movie]
    func getUpcomingMovies() async throws -> [Movie]
    func getPopularMovies() async throws -> [Movie]
    func getTopRatedMovies() async throws -> [Movie]
    func getSearchQuery(query: String) async throws -> [Movie]
}

class MovieDBRepository: MovieDBRepositoryProtocol {
    
    private let provider: MoyaProvider<APIManager>!
    
    init(provider: MoyaProvider<APIManager> = MoyaProvider<APIManager>()) {
        self.provider = provider
    }
    
    func getTrendingMovies() async throws -> [Movie] {
        let response: TrendingMovieResponse = try await provider.async.request(.getTrendingMovies)
        return response.results
    }
    
    func getTrendingTV() async throws -> [Movie] {
        let response: TrendingMovieResponse = try await provider.async.request(.getTrendingTV)
        return response.results
    }
    
    func getUpcomingMovies() async throws -> [Movie] {
        let response: TrendingMovieResponse = try await provider.async.request(.getUpcomingMovies)
        return response.results
    }
    
    func getPopularMovies() async throws -> [Movie] {
        let response: TrendingMovieResponse = try await provider.async.request(.getPopularMovies)
        return response.results
    }
    
    func getTopRatedMovies() async throws -> [Movie] {
        let response: TrendingMovieResponse = try await provider.async.request(.getTopRatedMovies)
        return response.results
    }
    
    func getSearchQuery(query: String) async throws -> [Movie] {
        let response: TrendingMovieResponse = try await provider.async.request(.getSearchQuery(query: query))
        return response.results
    }
}
