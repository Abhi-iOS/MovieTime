//
//  GenreCell.swift
//  Movies
//
//  Created by Appinventiv on 16/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class GenreCell: UITableViewCell {

    //MARK: outlets
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var movieCollection: UICollectionView!
    override func awakeFromNib() {
        
        //MARK: awakeFromNib
        super.awakeFromNib()
        // Initialization code
        
        //registering nib for item of GenreCell
        let nib = UINib(nibName: "ContentCell", bundle: nil)
        movieCollection.register(nib, forCellWithReuseIdentifier: "ContentCellID")
        
        movieCollection.delegate = self
        movieCollection.dataSource = self
        
        //formatting items of movieCollection
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 78, height: 78)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .horizontal
        movieCollection.collectionViewLayout = flowLayout

    }
}


   
extension GenreCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    //returns number of items in movieCollection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 10
    }
    
    //returns items of movieCollection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let movieItem = movieCollection.dequeueReusableCell(withReuseIdentifier: "ContentCellID", for: indexPath) as? ContentCell else{ fatalError("Item Not Found") }
        
        return movieItem
    }
    
}
