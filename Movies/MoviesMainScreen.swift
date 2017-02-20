//
//  MoviesMainScreen.swift
//  Movies
//
//  Created by Appinventiv on 16/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class MoviesMainScreen: UIViewController {

    //MARK: variables
    var favItem = [[IndexPath]]()
    var collapsedIndex : [IndexPath] = []
    
    //MARK: outlets
    @IBOutlet weak var movieList: UITableView!
    
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        
        
        //registering nib for cell of movieList
        let nibCell = UINib(nibName: "GenreCell", bundle: nil)
        movieList.register(nibCell, forCellReuseIdentifier: "GenreCellID")
        
        //registering nib for header of movieList
        let sectionNib = UINib(nibName: "SectionHeader", bundle: nil)
        movieList.register(sectionNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderID")
        
        movieList.dataSource = self
        movieList.delegate = self
        
    }
   
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension MoviesMainScreen: UITableViewDelegate, UITableViewDataSource{
    
    //returns number of section in movieList
    func numberOfSections(in tableView: UITableView) -> Int{
        return MovieDataDictionary.movieDictionary.count
    }
    
    //formatting header for section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionTitle = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderID") as?SectionHeader else{ fatalError("Section Not Found") }
        
        sectionTitle.categoryTitle.text = MovieDataDictionary.movieDictionary[section]["category"] as? String
        
        sectionTitle.categoryTitle.backgroundColor = UIColor.lightGray
        sectionTitle.categoryTitle.textColor = .white
        
        return sectionTitle
    }
    
    //return height of section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //return number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let movieGenre = MovieDataDictionary.movieDictionary[section]["movieGenre"] as? [[String:Any]]
        
        return movieGenre!.count
    }
    
    //formating rows of movieList
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let genreCell = tableView.dequeueReusableCell(withIdentifier: "GenreCellID", for: indexPath) as? GenreCell else{ fatalError("Cell Not Found") }
        
        if collapsedIndex.contains(indexPath){
            genreCell.expandCell.isSelected = true
        }        
        genreCell.expandCell.addTarget(self, action: #selector(expandCellRequested), for: .touchUpInside)
        
        
        let movieGenre = MovieDataDictionary.movieDictionary[indexPath.section]["movieGenre"] as? [[String:Any]]
        
        genreCell.configureWithData(data: movieGenre!, indexPath: indexPath)
        
        
        genreCell.movieCollection.dataSource = self
        genreCell.movieCollection.delegate = self
        
        //registering nib for item of GenreCell
        let nibItem = UINib(nibName: "ContentCell", bundle: nil)
        genreCell.movieCollection.register(nibItem, forCellWithReuseIdentifier: "ContentCellID")
        
        
        //formatting items of movieCollection
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 115, height: 115)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .horizontal
        genreCell.movieCollection.collectionViewLayout = flowLayout
        
        
        return genreCell
        
    }
    
    //returns hieght of row for MovieList
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if (collapsedIndex.contains(indexPath)){
            
            return 30
        }

        else{
        return 150
        }
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension MoviesMainScreen : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    //returns number of items in movieCollection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        //let movieGenre = MovieDataDictionary.movieDictionary[section]["movieGenre"] as? [[String:Any]]
        
        
        return 10
    }
    
    //returns items of movieCollection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        
        guard let movieItem = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCellID", for: indexPath) as? ContentCell else{ fatalError("Item Not Found") }
        
        movieItem.backgroundColor = .random
        
        
        movieItem.addFavourties.addTarget(self, action: #selector(addFavourtiesTapped), for: .touchUpInside)
      
        return movieItem
    }
    
    //detailed view of selected cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailedImageViewPage = self.storyboard?.instantiateViewController(withIdentifier: "DetailedImageViewID") as! DetailedImageViewVC
        UIView.animate(withDuration: 0.8, animations: {

            UIView.setAnimationCurve(.easeInOut)
            
            self.navigationController?.pushViewController(detailedImageViewPage, animated: false)
            
            UIView.setAnimationTransition(.curlUp, for: self.navigationController!.view!, cache: false)

        })
            
        
//        self.navigationController?.pushViewController(detailedImageViewPage, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath)
        detailedImageViewPage.imageColor = cell?.backgroundColor
        
        
    }
   
        
}

