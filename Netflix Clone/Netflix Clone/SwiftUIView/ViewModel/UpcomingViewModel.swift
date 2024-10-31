//
//  UpcomingViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import SwiftUI

protocol UpcomingViewModelDelegate {
    func pushYoutubeWebView(title: Movie)
    func showErrorMessage(error: String)
}

@Observable
class UpcomingViewModel {
    var titles: [Movie] = []
    
    // MARK: - Init
    
    private let repository: MovieDBRepositoryProtocol
    private let delegate: UpcomingViewModelDelegate

    init(
        repository: MovieDBRepositoryProtocol = MovieDBRepository(),
        delegate: UpcomingViewModelDelegate
    ) {
        self.repository = repository
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    func didClickedItem(_ title: Movie) {
        delegate.pushYoutubeWebView(title: title)
    }

    func onAppear() async {
        guard titles.isEmpty else { return }
        await getUpComingMovies()
    }
    
    func onRefresh() async {
        await getUpComingMovies()
    }

    private func getUpComingMovies() async {
        do {
            titles = try await repository.getUpcomingMovies().shuffled()
        } 
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }
}
