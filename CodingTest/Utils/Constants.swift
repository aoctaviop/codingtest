//
//  Constants.swift
//  CodingTest
//
//  Created by Andrés Padilla on 22/6/21.
//

import UIKit

enum Categories: Int {
    case Popular = 0
    case TopRated
    case Upcoming
}

struct Constants {
    struct CellIdentifier {
        static let Movie = "MovieCell"
        static let Label = "LabelCell"
        static let Info = "InfoCell"
        static let Poster = "PosterCell"
        static let Video = "VideoCell"
    }
    struct Filename {
        static let Genres = "Genres"
        static let Movies = "Movies-%@"
        static let CurrentIndex = "CurrentIndex-%@"
        static let MaxIndex = "MaxIndex-%@"
    }
    struct ViewIdentifier {
        static let Movies = "MoviesViewController"
    }
}
