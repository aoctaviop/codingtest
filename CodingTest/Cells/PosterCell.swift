//
//  PosterCell.swift
//  CodingTest
//
//  Created by Andrés Padilla on 22/6/21.
//

import UIKit
import Alamofire
import AlamofireImage

class PosterCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    
    let imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(movie: Movie) {
        AF.request(movie.urlForBackdrop()).responseImage { response in
            if case .success(let image) = response.result {
                self.posterImageView.image = image
                self.imageCache.add(image, withIdentifier: "\(movie.id)-\(Suffix.backdrop)")
            } else {
                self.posterImageView.image = UIImage.placeholder()
            }
        }
    }
    
    @IBAction func trailerButtonPressed(_ sender: UIButton) {
        
    }
    
}
