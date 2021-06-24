//
//  Movie.swift
//  CodingTest
//
//  Created by Andrés Padilla on 22/6/21.
//

import UIKit

struct Movie: Decodable, Encodable {
    
    let id: Int
    let title: String
    let originalTitle: String
    let isAdult: Bool?
    let genres: [Int]?
    let releaseDate: Date?
    let hasVideo: Bool?
    let backdropPath: String?
    let posterPath: String?
    let language: String?
    let overview: String?
    let rating: Double?
    
    private enum CodingKeys : String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case isAdult = "adult"
        case genres = "genre_ids"
        case releaseDate = "release_date"
        case hasVideo = "video"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case language = "original_language"
        case overview
        case rating = "vote_average"
    }
    
    func urlForBackdrop() -> String {
        if let backdropPath = backdropPath{
            return String(format: API.URL.Image, backdropPath)
        }
        
        return ""
    }
    
    func urlForPoster() -> String {
        if let posterPath = posterPath{
            return String(format: API.URL.Image, posterPath)
        }
        
        return ""
    }
    
    func urlForVideo() -> String {
        return String(format: API.URL.Video, String(id), API.Constants.APIKey)
    }
}
