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
    var fetchMoviesResult: Result<[Title], MoyaError> = .failure(MoyaError.requestMapping(""))
    
    var didCallDownloadMovieWithTitle: Bool = false
    var didCallFetchMovies: Bool = false
    var didCallDeleteMovieWithTitle: Bool = false
    
    func downloadMovieWithTitle(model: Netflix_Clone.Title) async throws {
        didCallDownloadMovieWithTitle = true
    }
    
    func fetchMovies() async throws -> [Netflix_Clone.Title] {
        didCallFetchMovies = true
        switch fetchMoviesResult {
        case .success(let success):
            return success
        case .failure(let error):
            throw error
        }
    }
    
    func deleteMovieWithTitle(with title: Netflix_Clone.Title) async throws {
        didCallDeleteMovieWithTitle = true
    }
}
