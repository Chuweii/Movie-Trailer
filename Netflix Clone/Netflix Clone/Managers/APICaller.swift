//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/9/27.
//

import Foundation

struct APIURL{
    
    static let apiKey = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    
    static let youtubeAPI_KEY = "AIzaSyD6vdYFpw7mVD0013YaJV8XG1qHcjHm63E"
    static let baseYoutubeURL = "https://youtube.googleapis.com/youtube/v3/search"
}

enum APIError:Error{
    case failedTogetData
}

class APICaller{
    
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title] , Error>) -> Void){
        guard let url = URL(string: "\(APIURL.baseURL)/3/trending/movie/day?api_key=\(APIURL.apiKey)") else{return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
                
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        task.resume()
    }
    
    func getTrendingTv(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(APIURL.baseURL)/3/trending/tv/day?api_key=\(APIURL.apiKey)") else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovie(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(APIURL.baseURL)/3/movie/upcoming?api_key=\(APIURL.apiKey)") else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(APIURL.baseURL)/3/movie/popular?api_key=\(APIURL.apiKey)") else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    
    func getToprated(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(APIURL.baseURL)/3/movie/top_rated?api_key=\(APIURL.apiKey)") else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getSearchQuery(query:String,completion: @escaping (Result<[Title], Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(APIURL.baseURL)/3/search/movie?api_key=\(APIURL.apiKey)&query=\(query)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getYoutubeMovie(query:String, completion: @escaping (Result<VideoElement, Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{return}
        guard let url = URL(string: "\(APIURL.baseYoutubeURL)?q=\(query)&key=\(APIURL.youtubeAPI_KEY)") else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            
            do{
                print(url)
                let results = try JSONDecoder().decode(YoutubrSerchResponse.self, from: data)
                completion(.success(results.items[0]))
            }
            catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
