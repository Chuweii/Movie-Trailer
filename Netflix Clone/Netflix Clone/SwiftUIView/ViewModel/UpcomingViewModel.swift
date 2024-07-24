//
//  UpcomingViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import SwiftUI

protocol UpcomingViewModelDelegate {
    func pushYoutubeWebView(title: Title)
    func showErrorMessage(error: String)
}

@Observable
class UpcomingViewModel {
    var titles: [Title] = []
    
    // MARK: - Init
    
    let repository: MovieDBRepositoryProtocol
    let delegate: UpcomingViewModelDelegate

    init(
        repository: MovieDBRepositoryProtocol = MovieDBRepository(),
        delegate: UpcomingViewModelDelegate
    ) {
        self.repository = repository
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    func didClickedItem(_ title: Title) {
        delegate.pushYoutubeWebView(title: title)
    }

    func onAppear() async {
        await getUpComingMovies()
    }

    private func getUpComingMovies() async {
        guard titles.isEmpty else { return }
        do {
            titles = try await repository.getUpcomingMovies()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }
}
