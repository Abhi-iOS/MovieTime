//
//  FavouritesVC.swift
//  Movies
//
//  Created by Appinventiv on 17/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class DetailedImageViewVC: UIViewController {
    
    //MARK: variables
    var imageColor: UIColor!
    var nextPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    //MARK: outlets
    @IBOutlet weak var detailedImage: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        detailedImage.backgroundColor = imageColor
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(translateImage))
        self.detailedImage.addGestureRecognizer(pan)
        //detailedImage.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(false)
        
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
        UIView.setAnimationTransition(.curlDown, for: self.navigationController!.view!, cache: false)
        }, completion: nil)
        
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
