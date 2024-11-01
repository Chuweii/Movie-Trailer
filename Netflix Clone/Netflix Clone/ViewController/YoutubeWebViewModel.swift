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
    @Published var shouldShowToast: Bool = false
    private(set) var videoURL: URL?
    private(set) lazy var getMovieTitle: String = {
        movie.original_title ?? movie.original_name ?? ""
    }()

    // MARK: - Init
    
    private(set) var movie: Movie
    private let repository: YoutubeRepositoryProtocol
    private let dataPersistenceRepository: DataPersistenceRepositoryProtocol
    
    init(
        movie: Movie,
        repository: YoutubeRepositoryProtocol = YoutubeRepository(),
        dataPersistenceRepository: DataPersistenceRepositoryProtocol = DataPersistenceRepository()
    ) {
        self.movie = movie
        self.repository = repository
        self.dataPersistenceRepository = dataPersistenceRepository
    }
    
    func getYoutubeMovie() async {
        guard !shouldLoadVideo else { return }
        do {
            let video: VideoElement? = try await repository.getYoutubeMovie(query: "\(getMovieTitle) trailer ")
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
    
    func downloadMovie() async {
        do {
            try await dataPersistenceRepository.downloadMovie(movie: movie)
            self.shouldShowToast = true
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
}
