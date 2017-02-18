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

    
    enum SuperViewType: String{
        
        case UITableViewCell = "UITableViewCell"
        
        case UICollectionViewCell = "UICollectionViewCell"
    }
    
    class func getSuperView(subview: Any, superview: SuperViewType) -> Any{
        
        var subview = subview
        switch superview{
        case .UITableViewCell : while !(subview is UITableViewCell){
            subview = (subview as AnyObject).superview as Any
            }
            
        case .UICollectionViewCell : while !(subview is UICollectionViewCell){
            subview = (subview as AnyObject).superview as Any
            }
            
        }
        return subview
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


//contains action of button
extension MoviesMainScreen{
    
    //Adding to favourties section
    func addFavourtiesTapped(favButton: UIButton){
        
        favButton.isSelected = !favButton.isSelected
        
        var subview: Any = favButton
        subview = UIView.getSuperView(subview: subview, superview: UIView.SuperViewType.UICollectionViewCell)
        
        let collectionCell = subview as! ContentCell
        
        subview = UIView.getSuperView(subview: collectionCell, superview: UIView.SuperViewType.UITableViewCell)
        let tableCell = subview as! GenreCell
        
        let tableCellIndexPath = movieList.indexPath(for: tableCell)
        
        let collectionCellIndexPath = tableCell.movieCollection.indexPath(for: collectionCell)
        
        let favIndexPath = [tableCellIndexPath!,collectionCellIndexPath!]
        
        if favButton.isSelected == true{
            
            favItem.append(favIndexPath)
        }
            
        else{
            
            favItem.remove(at: favItem.index(where: { (indexPath: [IndexPath]) -> Bool in
                return indexPath == favIndexPath})!)
        }
        
        
        print(favItem)
    }
    
    //expanding the cell
    func expandCellRequested(expButton: UIButton){
        
        let genreCell = UIView.getSuperView(subview: expButton, superview: .UITableViewCell) as! GenreCell
        let indexs = self.movieList.indexPath(for: genreCell)!
        expButton.isSelected = !expButton.isSelected
        if expButton.isSelected{
            collapsedIndex.append(indexs)
            self.movieList.beginUpdates()
            self.movieList.endUpdates()
            
        }
        else{
            collapsedIndex.remove(at: collapsedIndex.index(of: indexs)!)
            self.movieList.beginUpdates()
            self.movieList.endUpdates()
        }
        
    }
    
    
}
