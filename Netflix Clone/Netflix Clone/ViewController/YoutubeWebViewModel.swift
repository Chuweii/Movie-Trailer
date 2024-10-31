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
        title.original_title ?? title.original_name ?? ""
    }()

    // MARK: - Init
    
    private(set) var title: Movie
    private let repository: YoutubeRepositoryProtocol
    private let dataPersistenceRepository: DataPersistenceRepositoryProtocol
    
    init(
        title: Movie,
        repository: YoutubeRepositoryProtocol = YoutubeRepository(),
        dataPersistenceRepository: DataPersistenceRepositoryProtocol = DataPersistenceRepository()
    ) {
        self.title = title
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
            try await dataPersistenceRepository.downloadMovieWithTitle(model: title)
            self.shouldShowToast = true
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
}
