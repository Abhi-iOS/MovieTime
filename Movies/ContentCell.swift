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
    
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
//        addFavourties.isSelected = false
        
        
    }

    
}
