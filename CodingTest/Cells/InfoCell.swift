//
//  InfoCell.swift
//  CodingTest
//
//  Created by Andrés Padilla on 22/6/21.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var adultImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(rating: String, language: String, isAdult: Bool) {
        ratingLabel.text = rating
        languageLabel.text = language
        adultImageView.tintColor = isAdult ? UIColor.red : UIColor.lightGray
    }
    
}
