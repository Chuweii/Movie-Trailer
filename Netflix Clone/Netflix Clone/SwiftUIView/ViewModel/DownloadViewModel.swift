//
//  DownloadViewModel.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/24.
//

import SwiftUI

protocol DownloadViewModelDelegate {
    func showErrorMessage(error: String)
}

@Observable
class DownloadViewModel {
    var titles: [Movie] = []

    // MARK: - Init

    private let repository: DataPersistenceRepositoryProtocol
    private let delegate: DownloadViewModelDelegate

    init(
        repository: DataPersistenceRepositoryProtocol = DataPersistenceRepository(),
        delegate: DownloadViewModelDelegate
    ) {
        self.repository = repository
        self.delegate = delegate
    }

    // MARK: - Methods

    func onAppear() async {
        await getDownloadMovies()
    }

    func onRefresh() async {
        await getDownloadMovies()
    }

    func swipeDeleteMovies(_ offsets: IndexSet) async {
        await deleteDownloadMovie(offsets)
        await onRefresh()
    }

    private func getDownloadMovies() async {
        do {
            titles = try await repository.fetchMovies()
        } catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    private func deleteDownloadMovie(_ offsets: IndexSet) async {
        for index in offsets {
            if index < titles.count {
                let titleToDelete = titles[index]
                do {
                    try await repository.deleteMovieWithTitle(with: titleToDelete)
                } catch {
                    delegate.showErrorMessage(error: error.localizedDescription)
                }
            }
        }
    }
}
