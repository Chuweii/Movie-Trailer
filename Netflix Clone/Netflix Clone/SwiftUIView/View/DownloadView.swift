//
//  DownloadView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/24.
//

import SwiftUI

struct DownloadView: View {
    let viewModel: DownloadViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.movies, id: \.id) { title in
                    CommonListRow(title: title, showPlayIcon: false) { _ in }
                }
                .onDelete(perform: { indexSet in
                    Task {
                        await viewModel.swipeDeleteMovies(indexSet)
                    }
                })
            }
            .refreshable {
                await viewModel.onRefresh()
            }
            .listStyle(.plain)
            .navigationTitle("Download")
            .task {
                await viewModel.onAppear()
            }
        }
    }
}
