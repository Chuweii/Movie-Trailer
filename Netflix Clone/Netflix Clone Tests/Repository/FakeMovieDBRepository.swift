//
//  FakeMovieDBRepository.swift
//  Netflix Clone Tests
//
//  Created by Wei Chu on 2024/7/25.
//

import Foundation
import Moya
@testable import Netflix_Clone

class FakeMovieDBRepository: MovieDBRepositoryProtocol {
    var getTrendingMoviesResult: Result<[Title], MoyaError> = .failure(MoyaError.requestMapping(""))
    var getTrendingTVResult: Result<[Title], MoyaError> = .failure(MoyaError.requestMapping(""))
    var getUpcomingMoviesResult: Result<[Title], MoyaError> = .failure(MoyaError.requestMapping(""))
    var getPopularMoviesResult: Result<[Title], Moya.MoyaError> = .failure(MoyaError.requestMapping(""))
    var getTopRatedMoviesResult: Result<[Title], MoyaError> = .failure(MoyaError.requestMapping(""))
    var getSearchQueryResult: Result<[Title], MoyaError> = .failure(MoyaError.requestMapping(""))
    
    var didCallGetTrendingMovies: Bool = false
    var didCallGetTrendingTV: Bool = false
    var didCallGetUpcomingMovies: Bool = false
    var didCallGetPopularMovies: Bool = false
    var didCallGetTopRatedMovies: Bool = false
    var didCallGetSearchQuery: Bool = false
    
    func getTrendingMovies() async throws -> [Netflix_Clone.Title] {
        didCallGetTrendingMovies = true
        switch getTrendingMoviesResult {
        case .success(let titles):
            return titles
        case .failure(let error):
            throw error
        }
    }
    
    func getTrendingTV() async throws -> [Netflix_Clone.Title] {
        didCallGetTrendingTV = true
        switch getTrendingTVResult {
        case .success(let titles):
            return titles
        case .failure(let error):
            throw error
        }
    }
    
    func getUpcomingMovies() async throws -> [Netflix_Clone.Title] {
        didCallGetUpcomingMovies = true
        switch getUpcomingMoviesResult {
        case .success(let titles):
            return titles
        case .failure(let error):
            throw error
        }
    }
    
    func getPopularMovies() async throws -> [Netflix_Clone.Title] {
        didCallGetPopularMovies = true
        switch getPopularMoviesResult {
        case .success(let titles):
            return titles
        case .failure(let error):
            throw error
        }
    }
    
    func getTopRatedMovies() async throws -> [Netflix_Clone.Title] {
        didCallGetTopRatedMovies = true
        switch getTopRatedMoviesResult {
        case .success(let titles):
            return titles
        case .failure(let error):
            throw error
        }
    }
    
    func getSearchQuery(query: String) async throws -> [Netflix_Clone.Title] {
        didCallGetSearchQuery = true
        switch getSearchQueryResult {
        case .success(let titles):
            return titles
        case .failure(let error):
            throw error
        }
    }
}
