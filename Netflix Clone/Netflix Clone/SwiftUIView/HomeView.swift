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
                BannerView(imageURL: $viewModel.bannerImage)
                
                HorizontalMoviesView(title: "Movie Trending".uppercased(), images: $viewModel.trendingMovies) { movieTitle in
                    
                }
                
                HorizontalMoviesView(title: "Popular".uppercased(), images: $viewModel.popularMovies) { movieTitle in
                    
                }

                HorizontalMoviesView(title: "TrendingTV".uppercased(), images: $viewModel.trendingTV) { movieTitle in
                    
                }

                HorizontalMoviesView(title: "Upcoming Movies".uppercased(), images: $viewModel.upComingMovies) { movieTitle in
                    
                }

                HorizontalMoviesView(title: "Top Rated".uppercased(), images: $viewModel.topRatedMovies) { movieTitle in
                    
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
