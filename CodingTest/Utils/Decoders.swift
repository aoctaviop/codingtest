//
//  Decoders.swift
//  CodingTest
//
//  Created by Andrés Padilla on 22/6/21.
//

import UIKit

class Decoders {
    
    class func genres(rawData: [[String: Any]]) -> [Genre] {
        do {
            let data = try JSONSerialization.data(withJSONObject: rawData, options: .prettyPrinted)
            
            let decoder = JSONDecoder()
        
            let parsedGenres = try decoder.decode([Genre].self, from: data)
            
            return parsedGenres
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func movies(rawData: [[String: Any]]) -> [Movie] {
        do {
            let data = try JSONSerialization.data(withJSONObject: rawData, options: [])
            
            let decoder = JSONDecoder()
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'"
            
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let parsedMovies = try decoder.decode([Movie].self, from: data)
            
            return parsedMovies
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func videos(rawData: [[String: Any]]) -> [Video] {
        do {
            let data = try JSONSerialization.data(withJSONObject: rawData, options: .prettyPrinted)
            
            let decoder = JSONDecoder()
        
            let parsedGenres = try decoder.decode([Video].self, from: data)
            
            return parsedGenres
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}
