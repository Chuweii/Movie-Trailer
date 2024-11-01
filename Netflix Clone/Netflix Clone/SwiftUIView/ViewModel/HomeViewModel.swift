//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import SwiftUI

protocol HomeViewModelDelegate {
    func pushYoutubeWebView(movie: Movie)
    func showErrorMessage(error: String)
    func showToast(_ message: String)
}

@Observable
class HomeViewModel {
    // MARK: - Properties

    var bannerImage: URL?
    var bannerMovie: Movie?
    var trendingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var trendingTV: [Movie] = []
    var upComingMovies: [Movie] = []
    var topRatedMovies: [Movie] = []

    // MARK: - Init

    private let movieDBRepository: MovieDBRepositoryProtocol
    private let dataPersistenceRepository: DataPersistenceRepositoryProtocol
    private let delegate: HomeViewModelDelegate

    init(
        movieDBRepository: MovieDBRepositoryProtocol = MovieDBRepository(),
        dataPersistenceRepository: DataPersistenceRepositoryProtocol = DataPersistenceRepository(),
        delegate: HomeViewModelDelegate
    ) {
        self.movieDBRepository = movieDBRepository
        self.dataPersistenceRepository = dataPersistenceRepository
        self.delegate = delegate
    }
    
    // MARK: - Click Action
    
    func didClickedImageItem(_ movie: Movie) {
        delegate.pushYoutubeWebView(movie: movie)
    }
    
    func didClickedPlay() {
        guard let movie = bannerMovie else { return }
        delegate.pushYoutubeWebView(movie: movie)
    }
    
    func didClickedDownload() async {
        guard let movie = bannerMovie else { return }
        await downloadMovie(movie)
    }
    
    func didLongPressImageItem(_ movie: Movie) async {
        await downloadMovie(movie)
    }
    
    // MARK: - API Call
    
    func onAppear() async {
        guard trendingMovies.isEmpty || popularMovies.isEmpty || trendingTV.isEmpty || upComingMovies.isEmpty || topRatedMovies.isEmpty else { return }
        await getAllMovies()
    }
    
    func onRefresh() async {
        await getAllMovies()
    }
    
    private func getAllMovies() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.getTrendingMovies() }
            group.addTask { await self.getPopularMovies() }
            group.addTask { await self.getTrendingTV() }
            group.addTask { await self.getUpComingMovies() }
            group.addTask { await self.getTopRatedMovies() }
        }
    }

    private func getTrendingMovies() async {
        do {
            trendingMovies = try await movieDBRepository.getTrendingMovies().shuffled()
            bannerMovie = trendingMovies.filter({ $0.poster_path != nil && $0.poster_path != "" }).randomElement()
            bannerImage = .movieDBImagePath(imagePath: bannerMovie?.poster_path ?? "")
        } 
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getPopularMovies() async {
        do {
            popularMovies = try await movieDBRepository.getPopularMovies().shuffled()
        }
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getTrendingTV() async {
        do {
            trendingTV = try await movieDBRepository.getTrendingTV().shuffled()
        }
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getUpComingMovies() async {
        do {
            upComingMovies = try await movieDBRepository.getUpcomingMovies().shuffled()
        }
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getTopRatedMovies() async {
        do {
            topRatedMovies = try await movieDBRepository.getTopRatedMovies().shuffled()
        }
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }
    
    // MARK: - Methods
    
    private func downloadMovie(_ movie: Movie) async {
        do {
            try await dataPersistenceRepository.downloadMovie(movie: movie)
            self.delegate.showToast("Downloaded!! 🥳🥳 Check out on Download page.")
        } 
        catch {
            self.delegate.showErrorMessage(error: error.localizedDescription)
        }
    }
}
