//
//  MovieCell.swift
//  CodingTest
//
//  Created by Andrés Padilla on 21/6/21.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
    }
    
    func loadMovie(movie: Movie) {
        titleLabel.text = movie.title
        
        AF.request(movie.urlForPoster()).responseImage { response in
            if case .success(let image) = response.result {
                self.posterImageView.image = image
                self.imageCache.add(image, withIdentifier: "\(movie.id)-poster")
            } else {
                self.posterImageView.image = nil
            }
        }
    }

}
