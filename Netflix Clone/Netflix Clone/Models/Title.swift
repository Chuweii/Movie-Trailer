//
//  Movie.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/27.
//

import Foundation
import CoreData

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
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

extension Title {
    init(titleItem: TitleItem) {
        id = Int(titleItem.id)
        media_type = titleItem.media_type
        original_language = titleItem.original_language ?? ""
        original_title = titleItem.original_title
        original_name = titleItem.original_name
        poster_path = titleItem.poster_path
        overview = titleItem.overview
        vote_count = Int(titleItem.vote_count)
        release_date = titleItem.release_date
        vote_average = titleItem.vote_average
    }
}

extension TitleItem {
    convenience init(context: NSManagedObjectContext, title: Title) {
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
