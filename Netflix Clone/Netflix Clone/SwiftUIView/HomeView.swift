//
//  HomeView.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/21.
//

import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                BannerView(imageURL: $viewModel.bannerImage) {
                    guard let title = viewModel.bannerTitle else { return }
                    viewModel.didClickedImageItem(title: title)
                } downloadAction: {
                    guard let title = viewModel.bannerTitle else { return }
                    viewModel.downloadMovie(title)
                }
                
                HorizontalMoviesView(
                    title: "Movie Trending".uppercased(),
                    images: $viewModel.trendingMovies
                ) { title in
                    viewModel.didClickedImageItem(title: title)
                } longPressAction: { title in
                    viewModel.didLongPressImageItem(title: title)
                }
                
                HorizontalMoviesView(
                    title: "Popular".uppercased(),
                    images: $viewModel.popularMovies
                ) { title in
                    viewModel.didClickedImageItem(title: title)
                } longPressAction: { title in
                    viewModel.didLongPressImageItem(title: title)
                }

                HorizontalMoviesView(
                    title: "TrendingTV".uppercased(),
                    images: $viewModel.trendingTV
                ) { title in
                    viewModel.didClickedImageItem(title: title)
                } longPressAction: { title in
                    viewModel.didLongPressImageItem(title: title)
                }

                HorizontalMoviesView(
                    title: "Upcoming Movies".uppercased(),
                    images: $viewModel.upComingMovies
                ) { title in
                    viewModel.didClickedImageItem(title: title)
                } longPressAction: { title in
                    viewModel.didLongPressImageItem(title: title)
                }

                HorizontalMoviesView(
                    title: "Top Rated".uppercased(),
                    images: $viewModel.topRatedMovies
                ) { title in
                    viewModel.didClickedImageItem(title: title)
                } longPressAction: { title in
                    viewModel.didLongPressImageItem(title: title)
                }
            }
        }
        .background(
            Color.black
        )
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
    }
}

#Preview {
    HomeViewController()
}
