//
//  SearchView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 5) {
                    ForEach(viewModel.titles, id: \.id) { title in
                        GridItemView(title: title) { title in
                            viewModel.didClickedItem(title)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer)
            .transition(.scale)
            .onAppear {
                Task {
                    await viewModel.onAppear()
                }
            }
        }
    }
}


struct GridItemView: View {
    @State var title: Title
    var action: (Title) -> Void
    private let itemHeight: CGFloat = 180

    var body: some View {
        AsyncImage(url: .init(string: .movieDBImagePath(imagePath: title.poster_path ?? ""))) { phase in
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
