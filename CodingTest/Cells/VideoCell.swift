//
//  VideoCell.swift
//  CodingTest
//
//  Created by Andrés Padilla on 22/6/21.
//

import UIKit

import Alamofire
import AlamofireImage

class VideoCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(video: Video) {
        captionLabel.text = video.name
        AF.request(String(format: API.URL.Thumbnail, video.key)).responseImage { response in
            if case .success(let image) = response.result {
                self.thumbnailImageView.image = image
            } else {
                self.thumbnailImageView.image = UIImage.placeholder()
            }
        }
    }

}
