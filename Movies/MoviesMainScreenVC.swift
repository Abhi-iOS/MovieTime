//
//  MoviesMainScreenVC.swift
//  Movies
//
//  Created by Appinventiv on 16/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class MoviesMainScreenVC: UIViewController {

    //MARK: variables
    var favItems: [[IndexPath]] = []
    var collapsedIndices : [IndexPath] = []
    var sectionsCollapsed: [Int] = []
    
    //MARK: outlets
    @IBOutlet weak var movieTable: UITableView!
    
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        
        
        //registering nib for cell of movieTable
        let tableCellNib = UINib(nibName: "GenreCell", bundle: nil)
        movieTable.register(tableCellNib, forCellReuseIdentifier: "GenreCellID")
        
        //registering nib for header of movieTable
        let sectionHeaderNib = UINib(nibName: "SectionHeader", bundle: nil)
        movieTable.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderID")
        
        movieTable.dataSource = self
        movieTable.delegate = self
        
    }
   
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension MoviesMainScreenVC: UITableViewDelegate, UITableViewDataSource{
    
    //returns number of section in movieTable
    func numberOfSections(in tableView: UITableView) -> Int{
        return MovieDataDictionary.movieDictionary.count
    }
    
    //formatting header for section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionHeaderTitle = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderID") as?SectionHeader else{ fatalError("Section Not Found") }
        
        sectionHeaderTitle.categoryTitle.text = MovieDataDictionary.movieDictionary[section]["category"] as? String
        
        sectionHeaderTitle.categoryTitle.backgroundColor = .lightGray
        sectionHeaderTitle.categoryTitle.textColor = .white
        
        sectionHeaderTitle.sectionContentCollapse.tag = section
        
        sectionHeaderTitle.sectionContentCollapse.addTarget(self, action: #selector(collapseContentOfSection), for: .touchUpInside)
        
        if sectionsCollapsed.contains(section){
            sectionHeaderTitle.sectionContentCollapse.isSelected = true
        }
        
        return sectionHeaderTitle
    }
    
    //return height of section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //return number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let movieGenre = MovieDataDictionary.movieDictionary[section]["movieGenre"] as? [[String:Any]]
        
        if sectionsCollapsed.contains(section){
            
            return 0
        }else {
        
        return movieGenre!.count
        }
    }
    
    //formating rows of movieTable
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let genreCell = tableView.dequeueReusableCell(withIdentifier: "GenreCellID", for: indexPath) as? GenreCell else{ fatalError("Cell Not Found") }
        
        if collapsedIndices.contains(indexPath){
            genreCell.expandCell.isSelected = true
        }        
        genreCell.expandCell.addTarget(self, action: #selector(expandCellRequested), for: .touchUpInside)
        
        
        let movieGenre = MovieDataDictionary.movieDictionary[indexPath.section]["movieGenre"] as? [[String:Any]]
        
        genreCell.configureWithData(data: movieGenre!, indexPath: indexPath)
        
        
        genreCell.movieCollection.dataSource = self
        genreCell.movieCollection.delegate = self
        
        //registering nib for item of GenreCell
        let contentCellNib = UINib(nibName: "ContentCell", bundle: nil)
        genreCell.movieCollection.register(contentCellNib, forCellWithReuseIdentifier: "ContentCellID")
        
        
        //formatting items of movieCollection
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 115, height: 115)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .horizontal
        genreCell.movieCollection.collectionViewLayout = flowLayout
        
        
        return genreCell
        
    }
    
    //returns hieght of row for movieTable
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if (collapsedIndices.contains(indexPath)){
            
            return 30
        } else {
        
            return 150
        
        }
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension MoviesMainScreenVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
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
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseInOut, animations: {
            
            self.navigationController?.pushViewController(detailedImageViewPage, animated: false)
            UIView.setAnimationTransition(.curlUp, for: (self.navigationController?.view)!, cache: false)
        }, completion: nil)
        
        let cell = collectionView.cellForItem(at: indexPath)
        detailedImageViewPage.imageColor = cell?.backgroundColor
        
        
    }
   
        
}

extension MoviesMainScreenVC{
    
    //Adding to favourties section
    func addFavourtiesTapped(favButton: UIButton){
        
        favButton.isSelected = !favButton.isSelected
        
        
        
        guard let collectionCell = favButton.getCollectionViewCell as! ContentCell? else{ return
        }
        
        guard let tableCell = collectionCell.getTableViewCell as! GenreCell? else{ return
        }

        let tableCellIndices = movieTable.indexPath(for: tableCell)
        
        let collectionCellIndices = tableCell.movieCollection.indexPath(for: collectionCell)
        
        let favIndexPath = [tableCellIndices!,collectionCellIndices!]
        
        if favButton.isSelected == true{
            
            favItems.append(favIndexPath)
        }
            
        else{
            
            favItems = favItems.filter({ (indices : [IndexPath]) -> Bool in
                return indices != favIndexPath
            })
            
        }
        
        
       print(favItems)
    }
    
    //expanding the cell
    func expandCellRequested(expButton: UIButton){
        
        guard let genreCell = expButton.getTableViewCell as? GenreCell else{ return
        }
        
        let indexs = self.movieTable.indexPath(for: genreCell)!
        
        expButton.isSelected = !expButton.isSelected
        
        if expButton.isSelected{
            
            collapsedIndices.append(indexs)
            self.movieTable.reloadRows(at: [indexs], with: .fade)
            
        }else {
            
            collapsedIndices = collapsedIndices.filter({ (indices : IndexPath) -> Bool in
                return indices != indexs
            })
            
            self.movieTable.reloadRows(at: [indexs], with: .fade)
        }
        
    }
    
    //collapsing contents of section
    func collapseContentOfSection(collapseSection: UIButton){
        
        let sectionToCollapse = collapseSection.tag
        
        collapseSection.isSelected = !collapseSection.isSelected
        
        if collapseSection.isSelected{
            sectionsCollapsed.append(sectionToCollapse)
        }else {
            
            sectionsCollapsed = sectionsCollapsed.filter({ (section) -> Bool in
                return section != sectionToCollapse
            })
        }
        self.movieTable.reloadSections([sectionToCollapse], with: .fade)
    }
    
}
