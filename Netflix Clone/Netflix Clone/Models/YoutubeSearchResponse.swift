//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/30.
//

import Foundation


//items =     (
//            {
//        etag = cT9OLqKDImyV9hTW8b5FEZkVtLI;
//        id =             {
//            kind = "youtube#video";
//            videoId = a9tq0aS5Zu8;
//        };
//        kind = "youtube#searchResult";
//    },


struct YoutubrSerchResponse: Codable{
    let items:[VideoElement]
}

struct VideoElement:Codable{
    let id:IdVideoElement
}

struct IdVideoElement:Codable{
    let kind:String
    let videoId :String
}
