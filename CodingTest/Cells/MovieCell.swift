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
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
        shadowView.isHidden = true
    }
    
    func loadMovie(movie: Movie, width: CGFloat) {
        titleLabel.text = movie.title
        
        shadowView.isHidden = false
        
        if NetworkState.isConnected() {
            AF.request(movie.urlForPoster(width: width)).responseImage { response in
                if case .success(let image) = response.result {
                    self.shadowView.isHidden = true
                    self.posterImageView.image = image
                    self.imageCache.add(image, withIdentifier: "\(movie.id)-\(Suffix.poster)")
                } else {
                    self.posterImageView.image = UIImage.placeholder()
                    self.shadowView.isHidden = false
                }
            }
        }
    }

}
