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
    var titles: [Title] = []

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
        await getUpComingMovies()
    }

    private func getUpComingMovies() async {
        do {
            self.titles = try await repository.fetchMovies()
        }
        catch {
            delegate.showErrorMessage(error: error.localizedDescription)
        }
    }

    func deleteDownloadMovie(_ offsets: IndexSet) async {
        for index in offsets {
            if index < titles.count {
                let titleToDelete = titles[index]
                do {
                    try await repository.deleteMovieWithTitle(with: titleToDelete)
                    self.titles.remove(at: index)
                } 
                catch {
                    self.delegate.showErrorMessage(error: error.localizedDescription)

                }
            }
        }
    }
}
