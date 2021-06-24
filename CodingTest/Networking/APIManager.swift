//
//  APIManager.swift
//  CodingTest
//
//  Created by Andrés Padilla on 21/6/21.
//

import UIKit
import Alamofire

struct API {
    struct URL {
        static let Base = "https://api.themoviedb.org/3/"
        static let Image = "https://image.tmdb.org/t/p/w500/%@"
        static let RequestToken = "auth/request_token"
        static let Genres = "genre/movie/list"
        static let Popular = "movie/popular"
        static let TopRated = "movie/top_rated"
        static let Upcoming = "movie/upcoming"
        static let Search = "/search/movie"
        static let Videos = "/movie/%@/videos"
        static let Thumbnail = "http://img.youtube.com/vi/%@/hqdefault.jpg"
        static let Video = "https://www.youtube.com/watch?v=%@"
    }
    struct Constants {
        static let APIKey = "8dff87a487d467bc7aca694de89336e5"
        static let AccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZGZmODdhNDg3ZDQ2N2JjN2FjYTY5NGRlODkzMzZlNSIsInN1YiI6IjYwZDEyYjhlYTI3NTAyMDA0NzljMTNjNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.70HtjKap0L4X4GMN8thquYbW_O6jkveVVbuKVqO_d9o"
    }
}

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    
    //This prevents others from using the default '()' initializer for this class.
    private override init() {}
    
    private func urlForEndpoint(endpoint: String) -> String {
        return API.URL.Base + endpoint
    }
    
    //MARK: - Base
    
    private func baseGETRequest(url: String, params: [String: Any], callback: @escaping (Any?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: API.Constants.AccessToken)
        ]
        
        AF.request(url, parameters: params, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                callback(value, nil)
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
    
    //MARK: - Methods
    
    func requestGenres(callback: @escaping ([Genre], Error?) -> Void) {
        let params: [String : Any] = [
            "api_key": API.Constants.APIKey,
            "language": "en-US",
        ]
        
        baseGETRequest(url: urlForEndpoint(endpoint: API.URL.Genres), params: params) { response, error in
            if let response = response as? [String: Any] {
                let genres = response["genres"] as! [[String: Any]]
                
                let parsedGenres = Decoders.genres(rawData: genres)
                
                callback(parsedGenres, nil)
            } else {
                callback([], nil)
            }
        }
    }
    
    func requestMovies(type: Categories, page: Int, callback: @escaping ([Movie], Int, Int, Error?) -> Void) {
        
        let endpoint = type == .Popular ? API.URL.Popular : type == .TopRated ? API.URL.TopRated : API.URL.Upcoming
        
        baseGETRequest(url: urlForEndpoint(endpoint: endpoint), params: ["page": page]) { response, error in
            if let response = response as? [String: Any] {
                let movies = response["results"] as! [[String: Any]]
                let page = response["page"] as! Int
                let max = response["total_pages"] as! Int
                
                let parsedMovies = Decoders.movies(rawData: movies)
                callback(parsedMovies, page, max, nil)
            } else {
                callback([], page, 0, nil)
            }
        }
    }
    
    func searchMovies(query: String, page: Int, callback: @escaping ([Movie], Int, Int, Error?) -> Void) {
        let params: [String : Any] = [
            "api_key": API.Constants.APIKey,
            "language": "en-US",
            "query": query
        ]
        
        baseGETRequest(url: urlForEndpoint(endpoint: API.URL.Search), params: params) { response, error in
            if let response = response as? [String: Any] {
                let movies = response["results"] as! [[String: Any]]
                let page = response["page"] as! Int
                let max = response["total_pages"] as! Int
                
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: movies,
                    options: []) {
                    let theJSONText = String(data: theJSONData,
                                               encoding: .ascii)
                    print("JSON string = \(theJSONText!)")
                }
                
                let parsedMovies = Decoders.movies(rawData: movies)
                callback(parsedMovies, page, max, nil)
            } else {
                callback([], page, 0, nil)
            }
        }
    }
    
    func getVideos(movieID: String, callback: @escaping ([Video], Error?) -> Void) {
        let params: [String : Any] = [
            "api_key": API.Constants.APIKey,
            "language": "en-US",
        ]
        
        baseGETRequest(url: urlForEndpoint(endpoint: String(format: API.URL.Videos, movieID)), params: params) { response, error in
            if let response = response as? [String: Any] {
                let videos = response["results"] as! [[String: Any]]
                let parsedVideos = Decoders.videos(rawData: videos)
                callback(parsedVideos, nil)
            } else {
                callback([], nil)
            }
        }
    }
}
