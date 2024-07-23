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
    let overViewText: String
    let repository: YoutubeRepository
    @Published var shouldLoadVideo: Bool = false
    
    init(
        video: VideoElement? = nil,
        movieTitle: String,
        overViewText: String,
        repository: YoutubeRepository = .init()
    ) {
        self.video = video
        self.movieTitle = movieTitle
        self.overViewText = overViewText
        self.repository = repository
    }
    
    func getYoutubeMovie() async {
        do {
            video = try await repository.getYoutubeMovie(query: "\(movieTitle) trailer ")
            shouldLoadVideo = true
        } catch {
            print(error.localizedDescription)
        }
    }
}
