//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import SwiftUI

protocol HomeViewModelDelegate {
    func pushYoutubeWebView(title: Title)
    func showErrorMessage(error: String)
    func showToast(_ message: String)
}

@Observable
class HomeViewModel {
    // MARK: - Properties

    var bannerImage: String = ""
    var bannerTitle: Title?
    var trendingMovies: [Title] = []
    var popularMovies: [Title] = []
    var trendingTV: [Title] = []
    var upComingMovies: [Title] = []
    var topRatedMovies: [Title] = []

    // MARK: - Init

    private let repository: MovieDBRepositoryProtocol
    private let delegate: HomeViewModelDelegate

    init(
        repository: MovieDBRepositoryProtocol = MovieDBRepository(),
        delegate: HomeViewModelDelegate
    ) {
        self.repository = repository
        self.delegate = delegate
    }
    
    // MARK: - Click Action
    
    func didClickedImageItem(_ title: Title) {
        delegate.pushYoutubeWebView(title: title)
    }
    
    func didClickedPlay(_ title: Title) {
        delegate.pushYoutubeWebView(title: title)
    }
    
    func didClickedDownload(_ title: Title) async {
        await downloadMovie(title)
    }
    
    func didLongPressImageItem(_ title: Title) async {
        await downloadMovie(title)
    }
    
    // MARK: - API Call
    
    func onAppear() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.getTrendingMovies() }
            group.addTask { await self.getPopularMovies() }
            group.addTask { await self.getTrendingTV() }
            group.addTask { await self.getUpComingMovies() }
            group.addTask { await self.getTopRatedMovies() }
        }
    }

    private func getTrendingMovies() async {
        guard trendingMovies.isEmpty, bannerImage.isEmpty else { return }
        do {
            trendingMovies = try await repository.getTrendingMovies()
            bannerTitle = trendingMovies.filter({ $0.poster_path != nil }).randomElement()
            bannerImage = .movieDBImagePath(imagePath: bannerTitle?.poster_path ?? "")
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getPopularMovies() async {
        guard popularMovies.isEmpty else { return }
        do {
            popularMovies = try await repository.getPopularMovies()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getTrendingTV() async {
        guard trendingTV.isEmpty else { return }
        do {
            trendingTV = try await repository.getTrendingTV()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getUpComingMovies() async {
        guard upComingMovies.isEmpty else { return }
        do {
            upComingMovies = try await repository.getUpcomingMovies()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getTopRatedMovies() async {
        guard topRatedMovies.isEmpty else { return }
        do {
            topRatedMovies = try await repository.getTopRatedMovies()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }
    
    // MARK: - Methods
    
    private func downloadMovie(_ title: Title) async {
        await DataPersistenceManager.shared.downloadTitleWith(model: title) { result in
            switch result{
            case .success():
                NotificationCenter.default.post(name: Notification.Name("downloaded"), object: nil)
                self.delegate.showToast("Downloaded!! 🥳🥳 Check out on Download page.")

            case .failure(let error):
                self.delegate.showErrorMessage(error: error.localizedDescription)
            }
        }
    }
}
