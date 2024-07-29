//
//  HomeViewModelSpec.swift
//  Netflix Clone Tests
//
//  Created by Wei Chu on 2024/7/21.
//

import Quick
import Nimble
@testable import Netflix_Clone

class HomeViewModelSpec: AsyncSpec {
    override class func spec() {
        // MARK: - Properties

        var delegate: MockHomeViewModelDelegate!
        var repository: FakeMovieDBRepository!
        var viewModel: HomeViewModel!
        
        beforeEach {
            delegate = MockHomeViewModelDelegate()
            repository = FakeMovieDBRepository()
            viewModel = HomeViewModel(movieDBRepository: repository, delegate: delegate)
        }
        
        describe("get trending movies") {
            context("when get trending movies success") {
                beforeEach {
                    repository.getTrendingMoviesResult = .success(getDummyTitles())
                    await viewModel.onAppear()
                }
                
                it("should update trending movies") {
                    expect(viewModel.trendingMovies.count).to(beGreaterThan(0))
                }
            }
        }
        
        describe("get popular movies") {
            context("when get popular movies success") {
                beforeEach {
                    repository.getPopularMoviesResult = .success(getDummyTitles())
                    await viewModel.onAppear()
                }
                
                it("should update popular movies") {
                    expect(viewModel.popularMovies.count).to(beGreaterThan(0))
                }
            }
        }
        
        describe("get upcoming movies") {
            context("when get upcoming movies success") {
                beforeEach {
                    repository.getUpcomingMoviesResult = .success(getDummyTitles())
                    await viewModel.onAppear()
                }
                
                it("should update upcoming movies") {
                    expect(viewModel.upComingMovies.count).to(beGreaterThan(0))
                }
            }
        }
        
        describe("get trending TV") {
            context("when get trending TV success") {
                beforeEach {
                    repository.getTrendingTVResult = .success(getDummyTitles())
                    await viewModel.onAppear()
                }
                
                it("should update trending TV") {
                    expect(viewModel.trendingTV.count).to(beGreaterThan(0))
                }
            }
        }
        
        describe("get top rated movies") {
            context("when get top rated movies success") {
                beforeEach {
                    repository.getTopRatedMoviesResult = .success(getDummyTitles())
                    await viewModel.onAppear()
                }
                
                it("should update top rated movies") {
                    expect(viewModel.topRatedMovies.count).to(beGreaterThan(0))
                }
            }
        }
        
        describe("get any movies") {
            context("when get movies failure") {
                beforeEach {
                    await viewModel.onAppear()
                }
                
                it("should show error message") {
                    expect(delegate.didCallShowErrorMessage).to(beTrue())
                }
            }
        }
        
        describe("play button") {
            context("when clicked play button") {
                beforeEach {
                    viewModel.didClickedPlay(getDummyTitles()[0])
                }
                
                it("should push to youtube web screen") {
                    expect(delegate.didCallPushYoutubeWebView).to(beTrue())
                }
            }
        }
        
        describe("download button") {
            context("when clicked download button") {
                beforeEach {
                    await viewModel.didClickedDownload(getDummyTitles()[0])
                }
                
                it("should show toast") {
                    expect(delegate.didCallShowToast).to(beTrue())
                }
            }
        }
        
        describe("movie image item") {
            context("when clicked movie image item") {
                beforeEach {
                    viewModel.didClickedImageItem(getDummyTitles()[0])
                }
                
                it("should push to youtube web screen") {
                    expect(delegate.didCallPushYoutubeWebView).to(beTrue())
                }
            }
            
            context("when long press movie image item") {
                beforeEach {
                    await viewModel.didLongPressImageItem(getDummyTitles()[0])
                }
                
                it("should show toast") {
                    expect(delegate.didCallShowToast).to(beTrue())
                }
            }
        }
        
        // MARK: - Fake Data
        
        func getDummyTitles() -> [Title] {
            [
                Title(
                    id: 1,
                    media_type: "",
                    original_language: "",
                    original_title: "Spider Man",
                    original_name: "",
                    poster_path: "",
                    overview: "",
                    vote_count: 1,
                    release_date: "",
                    vote_average: 1
                ),
                Title(
                    id: 2,
                    media_type: "",
                    original_language: "",
                    original_title: "Harry Potter",
                    original_name: "",
                    poster_path: "",
                    overview: "",
                    vote_count: 2,
                    release_date: "",
                    vote_average: 2
                )
            ]
        }
    }
}
