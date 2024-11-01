//
//  SearchView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    private let spacing: CGFloat = 5

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing)
                    ],
                    spacing: spacing
                ) {
                    ForEach(viewModel.movies, id: \.id) { title in
                        GridItemView(title: title) { title in
                            viewModel.didClickedItem(title)
                        }
                    }
                }
                .padding(.horizontal, spacing)
                .padding(.vertical, spacing * 2)
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer)
            .transition(.scale)
            .task {
                await viewModel.onAppear()
            }
        }
    }
}

struct GridItemView: View {
    @State var title: Movie
    var action: (Movie) -> Void
    private let itemHeight: CGFloat = 200

    var body: some View {
        AsyncImage(url: .movieDBImagePath(imagePath: title.poster_path ?? "")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        action(title)
                    }
            default:
                ProgressView()
            }
        }
        .frame(height: itemHeight)
        .frame(maxWidth: .infinity)
    }
}
