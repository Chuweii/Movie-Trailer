//
//  FakeDataPersistenceRepository.swift
//  Netflix Clone Tests
//
//  Created by Wei Chu on 2024/7/30.
//

import Foundation
import Moya
@testable import Netflix_Clone

class FakeDataPersistenceRepository: DataPersistenceRepositoryProtocol {
    var fetchMoviesResult: Result<[Movie], MoyaError> = .failure(MoyaError.requestMapping(""))
    
    var didCallDownloadMovieWithTitle: Bool = false
    var didCallFetchMovies: Bool = false
    var didCallDeleteMovieWithTitle: Bool = false
    
    func downloadMovie(movie: Netflix_Clone.Movie) async throws {
        didCallDownloadMovieWithTitle = true
    }
    
    func fetchMovies() async throws -> [Netflix_Clone.Movie] {
        didCallFetchMovies = true
        switch fetchMoviesResult {
        case .success(let success):
            return success
        case .failure(let error):
            throw error
        }
    }
    
    func deleteMovie(with title: Netflix_Clone.Movie) async throws {
        didCallDeleteMovieWithTitle = true
    }
}
