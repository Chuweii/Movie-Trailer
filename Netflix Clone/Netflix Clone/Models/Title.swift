//
//  Movie.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/27.
//

import Foundation
import CoreData

struct TrendingTitleResponse:Codable{
    let results:[Title]
}

struct Title:Codable{
    let id:Int
    let media_type:String?
    let original_language:String?
    let original_title:String?
    let original_name:String?
    let poster_path:String?
    let overview:String?
    let vote_count:Int
    let release_date:String?
    let vote_average:Double
}

extension Title {
    init(titleItem: TitleItem) {
        self.id = Int(titleItem.id)
        self.media_type = titleItem.media_type
        self.original_language = titleItem.original_language ?? ""
        self.original_title = titleItem.original_title
        self.original_name = titleItem.original_name
        self.poster_path = titleItem.poster_path
        self.overview = titleItem.overview
        self.vote_count = Int(titleItem.vote_count)
        self.release_date = titleItem.release_date
        self.vote_average = titleItem.vote_average
    }
}

extension TitleItem {
    convenience init(context: NSManagedObjectContext, title: Title) {
        self.init(context: context)
        self.id = Int64(title.id)
        self.original_title = title.original_title
        self.original_name = title.original_name
        self.media_type = title.media_type
        self.overview = title.overview
        self.poster_path = title.poster_path
        self.release_date = title.release_date
        self.vote_count = Int64(title.vote_count)
        self.vote_average = title.vote_average
    }
}
