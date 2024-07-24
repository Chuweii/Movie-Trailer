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

    let repository: MovieDBRepositoryProtocol
    let delegate: DownloadViewModelDelegate

    init(
        repository: MovieDBRepositoryProtocol = MovieDBRepository(),
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
        await DataPersistenceManager.shared.fetchingTitleFromDataBase { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let titles):
                self.titles = titles
            case .failure(let error):
                delegate.showErrorMessage(error: error.localizedDescription)
            }
        }
    }

    func deleteDownloadMovie(_ offsets: IndexSet) async {
        for index in offsets {
            if index < titles.count {
                let titleToDelete = titles[index]
                await DataPersistenceManager.shared.deleteTitle(with: titleToDelete) { result in
                    switch result {
                    case .success(_):
                        self.titles.remove(at: index)
                        
                    case .failure(let error):
                        self.delegate.showErrorMessage(error: error.localizedDescription)
                    }
                }
            }
        }
    }
}
