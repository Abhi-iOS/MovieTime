//
//  ExtractSuperview.swift
//  Movies
//
//  Created by Appinventiv on 18/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit

//extending UIView to add function that gets superview
extension UIView{

    var getCollectionViewCell: UICollectionViewCell?{
        
        var subview = self
        
        while !(subview is UICollectionViewCell){
            
            guard let view = subview.superview else { return nil}
            subview = view
        }
        
        return subview as? UICollectionViewCell
    }
    
    var getTableViewCell: UITableViewCell?{
        
        var subview = self
        
        while !(subview is UITableViewCell){
            guard let view = subview.superview else { return nil}
            subview = view
        }

        return subview as? UITableViewCell

    }
}

// random color genreator
extension UIColor
{
    static var random : UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
}

