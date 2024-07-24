//
//  DownloadView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/24.
//

import SwiftUI

struct DownloadView: View {
    let viewModel: DownloadViewModel
    let imageSize: CGSize = .init(width: 100, height: 140)
    let iconSize: CGFloat = 30

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.titles, id: \.id) { title in
                    CommonListRow(title: title) { _ in }
                }
                .onDelete(perform: { indexSet in
                    Task {
                        await viewModel.deleteDownloadMovie(indexSet)
                    }
                })
            }
            .listStyle(.plain)
            .navigationTitle("Download")
            .onAppear {
                Task {
                    await viewModel.onAppear()
                }
            }
        }
    }
}
