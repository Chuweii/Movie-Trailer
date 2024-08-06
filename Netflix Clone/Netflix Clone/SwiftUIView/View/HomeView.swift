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
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    BannerView(imageURL: $viewModel.bannerImage) {
                        viewModel.didClickedPlay()
                    } downloadAction: {
                        await viewModel.didClickedDownload()
                    }

                    HorizontalMoviesView(
                        title: "Movie Trending".uppercased(),
                        images: $viewModel.trendingMovies
                    ) { title in
                        viewModel.didClickedImageItem(title)
                    } longPressAction: { title in
                        await viewModel.didLongPressImageItem(title)
                    }

                    HorizontalMoviesView(
                        title: "Popular".uppercased(),
                        images: $viewModel.popularMovies
                    ) { title in
                        viewModel.didClickedImageItem(title)
                    } longPressAction: { title in
                        await viewModel.didLongPressImageItem(title)
                    }

                    HorizontalMoviesView(
                        title: "TrendingTV".uppercased(),
                        images: $viewModel.trendingTV
                    ) { title in
                        viewModel.didClickedImageItem(title)
                    } longPressAction: { title in
                        await viewModel.didLongPressImageItem(title)
                    }

                    HorizontalMoviesView(
                        title: "Upcoming Movies".uppercased(),
                        images: $viewModel.upComingMovies
                    ) { title in
                        viewModel.didClickedImageItem(title)
                    } longPressAction: { title in
                        await viewModel.didLongPressImageItem(title)
                    }

                    HorizontalMoviesView(
                        title: "Top Rated".uppercased(),
                        images: $viewModel.topRatedMovies
                    ) { title in
                        viewModel.didClickedImageItem(title)
                    } longPressAction: { title in
                        await viewModel.didLongPressImageItem(title)
                    }
                }
            }
            .navigationTitle("Movie Trailer")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    profileBarItem
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
}

extension HomeView {
    @ViewBuilder
    var profileBarItem: some View {
        Button {
            print("profile...")
        } label: {
            Image(systemName: "person.crop.circle")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    HomeViewController()
}
