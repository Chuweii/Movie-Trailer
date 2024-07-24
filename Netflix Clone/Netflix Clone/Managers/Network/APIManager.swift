//
//  APIManager.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/19.
//

import Foundation
import Moya

enum APIManager {
    case getTrendingMovies
    case getTrendingTV
    case getUpcomingMovies
    case getPopularMovies
    case getTopRatedMovies
    case getSearchQuery(query: String)
    case getYoutubeMovie(query: String)
}

enum APIURL{
    static let APIKey = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    
    static let youtubeAPIKey = "AIzaSyD6vdYFpw7mVD0013YaJV8XG1qHcjHm63E"
    static let baseYoutubeURL = "https://youtube.googleapis.com/youtube/v3/search"
}

extension APIManager: TargetType {
    var baseURL: URL {
        switch self {
        // Youtube base url
        case .getYoutubeMovie:
            URL(string: APIURL.baseYoutubeURL)!
        default:
            URL(string: APIURL.baseURL)!
        }
    }

    var path: String {
        switch self {
        case .getTrendingMovies:
            "/3/trending/movie/day"
        case .getTrendingTV:
            "/3/trending/tv/day"
        case .getUpcomingMovies:
            "/3/movie/upcoming"
        case .getPopularMovies:
            "/3/movie/popular"
        case .getTopRatedMovies:
            "/3/movie/top_rated"
        case .getSearchQuery:
            "/3/search/movie"
        case .getYoutubeMovie:
            ""
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        switch self {
        case .getSearchQuery(let query):
            .requestParameters(parameters: ["api_key": APIURL.APIKey, "query": query], encoding: URLEncoding.queryString)
        case .getYoutubeMovie(let query):
            .requestParameters(parameters: ["q": query, "key": APIURL.youtubeAPIKey], encoding: URLEncoding.queryString)
        default:
            .requestParameters(parameters: ["api_key": APIURL.APIKey], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Content-type": "application/json"]
    }
}
