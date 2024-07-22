//
//  YoutubeWebViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import Foundation

class YoutubeWebViewModel {
    var video: VideoElement?
    
    let movieTitle: String
    let repository: YoutubeRepository
    
    init(
        video: VideoElement? = nil,
        movieTitle: String,
        repository: YoutubeRepository = .init()
    ) {
        self.video = video
        self.movieTitle = movieTitle
        self.repository = repository
    }
    
    func getYoutubeMovie() async {
        do {
            video = try await repository.getYoutubeMovie(query: "\(movieTitle) trailer ")
        } catch {
            print(error.localizedDescription)
        }
    }
}
