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

struct CellIdentifier {
    static let movie = "MovieCell"
    static let label = "LabelCell"
    static let info = "InfoCell"
    static let poster = "PosterCell"
    static let video = "VideoCell"
}

struct Filename {
    static let genres = "Genres"
    static let movies = "Movies-%@"
    static let currentIndex = "CurrentIndex-%@"
    static let maxIndex = "MaxIndex-%@"
}

struct ViewIdentifier {
    static let movies = "MoviesViewController"
}

struct Segue {
    static let toDetail = "ToDetail"
}

struct DateFormats {
    static let short = "MMM d, yyyy"
}

struct Storyboard {
    static let main = "Main"
}
