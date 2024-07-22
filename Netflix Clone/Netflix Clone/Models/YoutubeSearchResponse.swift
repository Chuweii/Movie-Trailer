//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/30.
//

import Foundation

struct YoutubeSearchResponse: Codable{
    let items:[VideoElement]
}

struct VideoElement:Codable{
    let id:IdVideoElement
}

struct IdVideoElement:Codable{
    let kind:String
    let videoId :String
}
