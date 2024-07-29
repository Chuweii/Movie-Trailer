//
//  YoutubeWebViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import Foundation

class YoutubeWebViewModel {
    // MARK: - Properties
    
    @Published var shouldLoadVideo: Bool = false
    @Published var errorMessage: String? = nil
    var video: VideoElement?

    // MARK: - Init
    
    let movieTitle: String
    let overViewText: String
    let repository: YoutubeRepositoryProtocol
    
    init(
        movieTitle: String,
        overViewText: String,
        repository: YoutubeRepository = .init()
    ) {
        self.movieTitle = movieTitle
        self.overViewText = overViewText
        self.repository = repository
    }
    
    func getYoutubeMovie() async {
        do {
            video = try await repository.getYoutubeMovie(query: "\(movieTitle) trailer ")
            shouldLoadVideo = true
        } 
        catch {
            errorMessage = error.localizedDescription
        }
    }
}
