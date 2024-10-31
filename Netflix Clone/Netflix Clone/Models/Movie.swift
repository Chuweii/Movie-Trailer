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
    init(movieItem: TitleItem) {
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

extension TitleItem {
    convenience init(context: NSManagedObjectContext, title: Movie) {
        self.init(context: context)
        id = Int64(title.id)
        original_title = title.original_title
        original_name = title.original_name
        media_type = title.media_type
        overview = title.overview
        poster_path = title.poster_path
        release_date = title.release_date
        vote_count = Int64(title.vote_count)
        vote_average = title.vote_average
    }
}
