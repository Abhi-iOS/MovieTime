//
//  FavouritesVC.swift
//  Movies
//
//  Created by Appinventiv on 17/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailedImageViewVC: UIViewController {
    
    //MARK: variables
    var url: URL!
    var nextPoint = CGPoint(x: 0, y: 0)
    
    //MARK: outlets
    @IBOutlet weak var detailedImage: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedImage.af_setImage(withURL: url)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(translateImage))
        self.detailedImage.addGestureRecognizer(pan)
        //detailedImage.isUserInteractionEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
       
    }
    
    //translate image on pan
    func translateImage(gesture: UIPanGestureRecognizer){
        
        nextPoint = gesture.translation(in: detailedImage)
        
        switch gesture.state {
        case .began: print("gesture begins")
            
        case .changed: detailedImage.transform = CGAffineTransform(translationX: nextPoint.x, y: nextPoint.y)
            
        case .ended:   print("gesture ended")
            
        default: print("default")
        }
        
    }
    
}
