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
    var videoURL: URL?

    // MARK: - Init
    
    private(set) var movieTitle: String
    private(set) var overViewText: String
    private let repository: YoutubeRepositoryProtocol
    
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
            let video: VideoElement? = try await repository.getYoutubeMovie(query: "\(movieTitle) trailer ")
            guard let videoId = video?.id.videoId else {
                errorMessage = "Not found video ID"
                return
            }
            videoURL = URL.youtubeURLPath(videoId: videoId)
            shouldLoadVideo = true
        } 
        catch {
            errorMessage = error.localizedDescription
        }
    }
}
