//
//  AdventureItemTableViewCell.swift
//  AdventureFinder
//
//  Created by Wayne Bangert on 3/24/16.
//  Copyright © 2016 Wayne Bangert. All rights reserved.
//

import UIKit

class AdventureItemTableViewCell: UITableViewCell {
    
    var adventure:AdventureItem?
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func configureView() {
        if let adventure = adventure {
            placeNameLabel.text = adventure.name
            addressLabel.text = adventure.address
//            ratingControl.rating = adventure.rating
        }
    }

}
