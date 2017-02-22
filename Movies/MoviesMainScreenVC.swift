//
//  MoviesMainScreenVC.swift
//  Movies
//
//  Created by Appinventiv on 16/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Foundation
import AlamofireImage


class MoviesMainScreenVC: UIViewController {

    //MARK: variables
    var collapsedIndices = [IndexPath]()
    
    var rowsData = ["cats","dogs","tiger", "horses"]
    var contentCellData = [[[ImageInfo]]]()
   
    var sectionsCollapsed = [Int]()
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for section in 0...2{
            self.contentCellData.append([])
            for data in rowsData{
                Webservices().fetchDataFromPixabay(withQuery: data,
                                               success: { (images : [ImageInfo]) in
                                                
                                                print("service hit")
                                                self.contentCellData[section].append(images)
                                                self.movieTable.reloadData()
                                                
                }) { (error : Error) in
                        print(error)
                
                }

            }
        }
        
    }

}

//MARK: UITableViewDelegate, UITableViewDataSource
extension MoviesMainScreenVC: UITableViewDelegate, UITableViewDataSource{
    
    //returns number of section in movieTable
    func numberOfSections(in tableView: UITableView) -> Int{
        return contentCellData.count
    }
    
    //formatting header for section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionHeaderTitle = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderID") as?SectionHeader else{ fatalError("Section Not Found") }
        
        
//        sectionHeaderTitle.categoryTitle.backgroundColor = .blue
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
        
        if sectionsCollapsed.contains(section){
            return 0
        }
        return contentCellData[section].count
    }
    
    //formating rows of movieTable
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let genreCell = tableView.dequeueReusableCell(withIdentifier: "GenreCellID", for: indexPath) as? GenreCell else{ fatalError("Cell Not Found") }
        
        if collapsedIndices.contains(indexPath){
            genreCell.expandCell.isSelected = true
        }
        
        genreCell.expandCell.addTarget(self, action: #selector(expandCellRequested), for: .touchUpInside)
        
        return genreCell
            
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let genreCell = cell as? GenreCell else{  return  }
        
        genreCell.genreLabel.text = rowsData[indexPath.row]
        
        genreCell.movieCollection.dataSource = self
        genreCell.movieCollection.delegate = self
        
        //registering nib for item of GenreCell
        let contentCellNib = UINib(nibName: "ContentCell", bundle: nil)
        genreCell.movieCollection.register(contentCellNib, forCellWithReuseIdentifier: "ContentCellID")
        
        genreCell.tag = indexPath.section
        genreCell.movieCollection.tag = indexPath.row
        
        movieTable.reloadData()
        
        
        
        //formatting items of movieCollection
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 115, height: 115)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .horizontal
        genreCell.movieCollection.collectionViewLayout = flowLayout
        
        genreCell.movieCollection.reloadData()
        
        
    }
    
    //returns hieght of row for movieTable
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if (collapsedIndices.contains(indexPath)){
            
            return 30
        }
        return 150
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension MoviesMainScreenVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    //returns number of items in movieCollection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return contentCellData[section][collectionView.tag].count
    }
    
    //returns items of movieCollection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let movieItem = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCellID", for: indexPath) as? ContentCell else{ fatalError("Item Not Found") }
        
        movieItem.addFavourties.addTarget(self, action: #selector(addFavourtiesTapped), for: .touchUpInside)
      
        return movieItem
    }
    
    //called when content cell is to be displayed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let contentCell = cell as! ContentCell
        
        guard let genreCell = contentCell.getTableViewCell as? GenreCell else{ return
        }
        
        let genreCellIndexPath = [genreCell.tag, genreCell.movieCollection.tag] as IndexPath
        
        let URl = URL(string: contentCellData[genreCellIndexPath.section][genreCellIndexPath.row][indexPath.row].previewURL)!
        
        contentCell.dataImage.af_setImage(withURL: URl)

        
        contentCell.imageLabel.text = "\(genreCellIndexPath.section).\(genreCellIndexPath.row).\(indexPath.row)"
        
    }
    
    //detailed view of selected cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailedImageViewPage = self.storyboard?.instantiateViewController(withIdentifier: "DetailedImageViewID") as! DetailedImageViewVC
        
        let contentCell = collectionView.cellForItem(at: indexPath) as! ContentCell
        
        guard let genreCell = contentCell.getTableViewCell as? GenreCell else{ return
        }
        
        let genreCellIndexPath = [genreCell.tag, genreCell.movieCollection.tag] as IndexPath
        
        
        let url = URL(string: contentCellData[genreCellIndexPath.section][genreCellIndexPath.row][indexPath.row].webformatURL)
        detailedImageViewPage.url = url
        
        self.navigationController?.pushViewController(detailedImageViewPage, animated: false)
        
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

        let tableCellIndexPath = movieTable.indexPath(for: tableCell)!
        
        let collectionCellIndexPath = tableCell.movieCollection.indexPath(for: collectionCell)!
        
        favButton.isSelected = !favButton.isSelected
        if favButton.isSelected{
            
            contentCellData[tableCellIndexPath.section][tableCellIndexPath.row][collectionCellIndexPath.row].isFav = true
        }
            
        else{
            
            contentCellData[tableCellIndexPath.section][tableCellIndexPath.row][collectionCellIndexPath.row].isFav = false
        }
        
    }
    
    //expanding the cell
    func expandCellRequested(expButton: UIButton){
        
        guard let genreCell = expButton.getTableViewCell as? GenreCell else{ return
        }
        
        guard let indexs = self.movieTable.indexPath(for: genreCell) else{ return }
        
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
