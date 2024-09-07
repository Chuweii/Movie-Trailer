//
//  YoutubeRepository.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/20.
//

import Foundation
import Moya

protocol YoutubeRepositoryProtocol {
    func getYoutubeMovie(query: String) async throws -> VideoElement
}

class YoutubeRepository: YoutubeRepositoryProtocol {

    private let provider: MoyaProvider<APIManager>!

    init(provider: MoyaProvider<APIManager> = MoyaProvider<APIManager>()) {
        self.provider = provider
    }

    func getYoutubeMovie(query: String) async throws -> VideoElement {
        let response: YoutubeSearchResponse = try await provider.async.request(.getYoutubeMovie(query: query))
        return response.items[0]
    }
}
