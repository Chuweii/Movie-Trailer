//
//  MovieDBRepository.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/20.
//

import Foundation
import Moya

protocol MovieDBRepositoryProtocol {
    func getTrendingMovies() async throws -> [Title]
    func getTrendingTV() async throws -> [Title]
    func getUpcomingMovies() async throws -> [Title]
    func getPopularMovies() async throws -> [Title]
    func getTopRatedMovies() async throws -> [Title]
    func getSearchQuery(query: String) async throws -> [Title]
}

class MovieDBRepository: MovieDBRepositoryProtocol {
    
    private let provider: MoyaProvider<APIManager>!
    
    init(provider: MoyaProvider<APIManager> = MoyaProvider<APIManager>()) {
        self.provider = provider
    }
    
    func getTrendingMovies() async throws -> [Title] {
        let response: TrendingTitleResponse = try await provider.async.request(.getTrendingMovies)
        return response.results
    }
    
    func getTrendingTV() async throws -> [Title] {
        let response: TrendingTitleResponse = try await provider.async.request(.getTrendingTV)
        return response.results
    }
    
    func getUpcomingMovies() async throws -> [Title] {
        let response: TrendingTitleResponse = try await provider.async.request(.getUpcomingMovies)
        return response.results
    }
    
    func getPopularMovies() async throws -> [Title] {
        let response: TrendingTitleResponse = try await provider.async.request(.getPopularMovies)
        return response.results
    }
    
    func getTopRatedMovies() async throws -> [Title] {
        let response: TrendingTitleResponse = try await provider.async.request(.getTopRatedMovies)
        return response.results
    }
    
    func getSearchQuery(query: String) async throws -> [Title] {
        let response: TrendingTitleResponse = try await provider.async.request(.getSearchQuery(query: query))
        return response.results
    }
}
