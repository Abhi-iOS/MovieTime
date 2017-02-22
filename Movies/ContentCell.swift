//
//  ContentCell.swift
//  Movies
//
//  Created by Appinventiv on 16/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ContentCell: UICollectionViewCell {

    //MARK: outlets
    @IBOutlet weak var addFavourties: UIButton!
    
    @IBOutlet weak var dataImage: UIImageView!
    
    @IBOutlet weak var imageLabel: UILabel!
    
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        addFavourties.isSelected = false
        dataImage.image = nil
        imageLabel.text = ""
        
    }

    
}
