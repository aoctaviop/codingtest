//
//  DetailViewController.swift
//  CodingTest
//
//  Created by Andrés Padilla on 21/6/21.
//

import UIKit

enum DetailCells: Int {
    case Trailer
    case Title
    case Info // Rating, Languaje, Adult
    case ReleaseDate
    case Overview
    case Genres
    case Count
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movie: Movie?
    var genres: [Genre]?
    var languages: [Languaje] = []
    
    var videos: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = movie!.title
        
        if let movie = movie {
            APIManager.sharedInstance.getVideos(movieID: String(movie.id)) { response, error in
                if (response.count > 0) {
                    self.videos = response
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getGenres() -> String {
        if let arrayOfGenres = genres {
            let movieGenres = arrayOfGenres.filter({ genre in
                (movie?.genres!.contains(genre.id))!
            })
            
            let genreNames: [String]? = movieGenres.map { genre in
                return genre.name
            }
            
            return genreNames?.joined(separator: "\n") ?? ""
        } else {
            return ""
        }
    }

}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailCells.Count.rawValue + videos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        
        switch DetailCells.init(rawValue: indexPath.row) {
        case .Title:
            let title = movie?.originalTitle == movie?.title ? movie?.title : "\(movie?.title ?? "") (\(movie?.originalTitle ?? ""))"
            let xCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.Label, for: indexPath) as! LabelCell
            xCell.setup(caption: "Title", text: title ?? "")
            cell = xCell
        case .Trailer:
            let xCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.Poster, for: indexPath) as! PosterCell
            xCell.setup(movie: movie!)
            cell = xCell
        case .ReleaseDate:
            let xCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.Label, for: indexPath) as! LabelCell
            var stringDate = "-"
            if let releaseDate = movie?.releaseDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                stringDate = dateFormatter.string(from: releaseDate)
            }
            xCell.setup(caption: "Release Date", text: stringDate)
            cell = xCell
        case .Info:
            let xCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.Info, for: indexPath) as! InfoCell
            var language = movie?.language
            if let index = languages.firstIndex(where: { current in
                current.code == movie?.language
            }) {
                language = languages[index].name
            }
            xCell.setup(rating: "\(movie!.rating!.rounded())", language: language ?? "", isAdult: movie!.isAdult!)
            cell = xCell
        case .Overview:
            let xCell = tableView.dequeueReusableCell(withIdentifier:Constants.CellIdentifier.Label, for: indexPath) as! LabelCell
            xCell.setup(caption: "Overview", text: movie!.overview!)
            cell = xCell
        case .Genres:
            let xCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.Label, for: indexPath) as! LabelCell
            xCell.setup(caption: "Genres", text: getGenres())
            cell = xCell
        default:
            let video = videos[indexPath.row - DetailCells.Count.rawValue]
            let xCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.Video, for: indexPath) as! VideoCell
            xCell.setup(video: video)
            cell = xCell
        }
        
        
        return cell!
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == DetailCells.Trailer.rawValue) {
            return tableView.bounds.height / 3
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == DetailCells.Trailer.rawValue) {
            return tableView.bounds.height / 3
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row >= DetailCells.Count.rawValue) {
            let video = videos[indexPath.row - DetailCells.Count.rawValue]
            if let url = URL(string: String(format: API.URL.Video, video.key)) {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
