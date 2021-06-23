//
//  LabelCell.swift
//  CodingTest
//
//  Created by Andrés Padilla on 21/6/21.
//

import UIKit

class LabelCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(caption: String, text: String) {
        captionLabel.text = caption
        titleLabel.text = text
    }

}
