//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/22.
//

import SwiftUI

protocol HomeViewModelDelegate {
    func showErrorMessage(error: String)
}

@Observable
class HomeViewModel {
    // MARK: - Properties

    var bannerImage: String = ""
    var trendingMovies: [Title] = []
    var popularMovies: [Title] = []
    var trendingTV: [Title] = []
    var upComingMovies: [Title] = []
    var topRatedMovies: [Title] = []

    // MARK: - Init

    private let repository: MovieDBRepository
    private let delegate: HomeViewModelDelegate

    init(
        repository: MovieDBRepository = .init(),
        delegate: HomeViewModelDelegate
    ) {
        self.repository = repository
        self.delegate = delegate
    }

    func onAppear() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.getTrendingMovies() }
            group.addTask { await self.getPopularMovies() }
            group.addTask { await self.getTrendingTV() }
            group.addTask { await self.getUpComingMovies() }
            group.addTask { await self.getTopRatedMovies() }
        }
    }

    func getTrendingMovies() async {
        guard trendingMovies.isEmpty, bannerImage.isEmpty else { return }

        do {
            trendingMovies = try await repository.getTrendingMovies()
            bannerImage = .movieDBImagePath(imagePath: trendingMovies.randomElement()?.poster_path ?? "")
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    func getPopularMovies() async {
        guard popularMovies.isEmpty else { return }

        do {
            popularMovies = try await repository.getPopularMovies()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    func getTrendingTV() async {
        guard trendingTV.isEmpty else { return }

        do {
            trendingTV = try await repository.getTrendingTV()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    func getUpComingMovies() async {
        guard upComingMovies.isEmpty else { return }

        do {
            upComingMovies = try await repository.getUpcomingMovies()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    func getTopRatedMovies() async {
        guard topRatedMovies.isEmpty else { return }

        do {
            topRatedMovies = try await repository.getTopRatedMovies()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }
}
