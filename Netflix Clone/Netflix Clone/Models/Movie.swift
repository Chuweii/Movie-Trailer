//
//  Movie.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/27.
//

import Foundation
import CoreData

struct TrendingMovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_language: String?
    let original_title: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

extension Movie {
    init(movieItem: MovieItem) {
        id = Int(movieItem.id)
        media_type = movieItem.media_type
        original_language = movieItem.original_language ?? ""
        original_title = movieItem.original_title
        original_name = movieItem.original_name
        poster_path = movieItem.poster_path
        overview = movieItem.overview
        vote_count = Int(movieItem.vote_count)
        release_date = movieItem.release_date
        vote_average = movieItem.vote_average
    }
}

extension MovieItem {
    convenience init(context: NSManagedObjectContext, movie: Movie) {
        self.init(context: context)
        id = Int64(movie.id)
        original_title = movie.original_title
        original_name = movie.original_name
        media_type = movie.media_type
        overview = movie.overview
        poster_path = movie.poster_path
        release_date = movie.release_date
        vote_count = Int64(movie.vote_count)
        vote_average = movie.vote_average
    }
}
