//
//  PersistenceManager.swift
//  CodingTest
//
//  Created by Andrés Padilla on 23/6/21.
//

import UIKit

class PersistenceManager: NSObject {

    class func saveGenres(genres: [Genre]) {
        Storage.store(genres, to: .caches, as: Constants.Filename.Genres)
    }
    
    class func loadGenres() -> [Genre] {
        if Storage.fileExists(Constants.Filename.Genres, in: .caches) {
            let genres = Storage.retrieve(Constants.Filename.Genres, from: .caches, as: [Genre].self)
            return genres
        }
        
        return []
    }
    
    class func saveMovieCategory(category: Categories , movies: [Movie], currentIndex: Int, maxIndex: Int) {
        let suffix = category == .Popular ? "popular" : category == .TopRated ? "top-rated" : "upcoming"
        Storage.store(currentIndex, to: .caches, as: String(format: Constants.Filename.CurrentIndex, suffix))
        Storage.store(maxIndex, to: .caches, as: String(format: Constants.Filename.MaxIndex, suffix))
        Storage.store(movies, to: .caches, as: String(format: Constants.Filename.Movies, suffix))
    }
    
    class func loadMovieCategory(category: Categories, callback: (_ movies: [Movie], _ currentIndex: Int, _ maxIndex: Int) -> Void) {
        let suffix = category == .Popular ? "popular" : category == .TopRated ? "top-rated" : "upcoming"
        if Storage.fileExists(String(format: Constants.Filename.Movies, suffix), in: .caches) {
            let movies = Storage.retrieve(String(format: Constants.Filename.Movies, suffix), from: .caches, as: [Movie].self)
            let currentIndex = Storage.retrieve(String(format: Constants.Filename.CurrentIndex, suffix), from: .caches, as: Int.self)
            let maxIndex = Storage.retrieve(String(format: Constants.Filename.MaxIndex, suffix), from: .caches, as: Int.self)
            
            callback(movies, currentIndex, maxIndex)
        } else {
            callback([], 0, 0)
        }
    }
    
}
