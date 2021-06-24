//
//  PersistenceManager.swift
//  CodingTest
//
//  Created by Andrés Padilla on 23/6/21.
//

import UIKit

class PersistenceManager: NSObject {

    class func saveGenres(genres: [Genre]) {
        Storage.store(genres, to: .caches, as: Filename.genres)
    }
    
    class func loadGenres() -> [Genre] {
        if Storage.fileExists(Filename.genres, in: .caches) {
            let genres = Storage.retrieve(Filename.genres, from: .caches, as: [Genre].self)
            return genres
        }
        
        return []
    }
    
    class func saveMovieCategory(category: Categories , movies: [Movie], currentIndex: Int, maxIndex: Int) {
        let suffix = category == .Popular ? Suffix.popular : category == .TopRated ? Suffix.topRated : Suffix.upcoming
        Storage.store(currentIndex, to: .caches, as: String(format: Filename.currentIndex, suffix))
        Storage.store(maxIndex, to: .caches, as: String(format: Filename.maxIndex, suffix))
        Storage.store(movies, to: .caches, as: String(format: Filename.movies, suffix))
    }
    
    class func loadMovieCategory(category: Categories, callback: (_ movies: [Movie], _ currentIndex: Int, _ maxIndex: Int) -> Void) {
        let suffix = category == .Popular ? Suffix.popular : category == .TopRated ? Suffix.topRated : Suffix.upcoming
        if Storage.fileExists(String(format: Filename.movies, suffix), in: .caches) {
            let movies = Storage.retrieve(String(format: Filename.movies, suffix), from: .caches, as: [Movie].self)
            let currentIndex = Storage.retrieve(String(format: Filename.currentIndex, suffix), from: .caches, as: Int.self)
            let maxIndex = Storage.retrieve(String(format: Filename.maxIndex, suffix), from: .caches, as: Int.self)
            
            callback(movies, currentIndex, maxIndex)
        } else {
            callback([], 1, -1)
        }
    }
    
}
