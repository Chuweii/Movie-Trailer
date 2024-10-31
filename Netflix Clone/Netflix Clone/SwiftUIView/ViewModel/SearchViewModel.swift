//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import Foundation
import SwiftUI
import Combine

protocol SearchViewModelDelegate {
    func pushYoutubeWebView(title: Movie)
    func showErrorMessage(error: String)
}

@MainActor
class SearchViewModel: ObservableObject {
    // MARK: - Properties

    @Published var titles: [Movie] = []
    @Published var searchText: String = ""
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - Init

    private let repository: MovieDBRepositoryProtocol
    private let delegate: SearchViewModelDelegate

    init(
        repository: MovieDBRepositoryProtocol = MovieDBRepository(),
        delegate: SearchViewModelDelegate
    ) {
        self.repository = repository
        self.delegate = delegate
        configureReactiveSearch()
    }

    // MARK: - Methods

    func didClickedItem(_ title: Movie) {
        delegate.pushYoutubeWebView(title: title)
    }

    func onAppear() async {
        await getPopularMovies()
    }

    private func getPopularMovies() async {
        guard titles.isEmpty else { return }
        do {
            titles = try await repository.getPopularMovies()
        } 
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func getSearchQuery() async {
        do {
            titles = try await repository.getSearchQuery(query: searchText)
        } 
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func configureReactiveSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .filter { $0.trimmingCharacters(in: .whitespaces).count >= 3 }
            .sink { [weak self] _ in
                Task { [weak self] in
                    await self?.getSearchQuery()
                }
            }
            .store(in: &cancellables)
    }
}
