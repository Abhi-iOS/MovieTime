//
//  FavouritesVC.swift
//  Movies
//
//  Created by Appinventiv on 17/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class DetailedImageViewVC: UIViewController {
    
    var imageColor: UIColor!
    
    @IBOutlet weak var detailedImage: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        detailedImage.backgroundColor = imageColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(false)
        
        UIView.animate(withDuration: 0.8, animations: {
            
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationTransition(.curlDown, for: self.navigationController!.view!, cache: false)
            
        })
        
    }
    
}
