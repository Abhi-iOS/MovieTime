//
//  SectionHeader.swift
//  Movies
//
//  Created by Appinventiv on 16/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {

    //MARK: outlets
    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var sectionContentCollapse: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        sectionContentCollapse.isSelected = false
    }
    
}
