//
//  MoviesMainScreen.swift
//  Movies
//
//  Created by Appinventiv on 16/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class MoviesMainScreen: UIViewController {

    //MARK: outlets
    @IBOutlet weak var movieList: UITableView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        
        
        //registering nib for cell of movieList
        let nib = UINib(nibName: "GenreCell", bundle: nil)
        movieList.register(nib, forCellReuseIdentifier: "GenreCellID")
        
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
        return 5
    }
    
    //formatting header for section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionTitle = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderID") as?SectionHeader else{ fatalError("Cell Not Found") }
        
        switch  section {
        case 0: sectionTitle.categoryTitle.text = "BOLLYWOOD"
        case 1: sectionTitle.categoryTitle.text = "HOLLYWOOD"
        case 2: sectionTitle.categoryTitle.text = "LOLLYWOOD"
        case 3: sectionTitle.categoryTitle.text = "TOLLYWOOD"
            
        default:  sectionTitle.categoryTitle.text = "BOLLYWOOD"
        }
        
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
        return 4
    }
    
    //formating rows of movieList
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let genreCell = tableView.dequeueReusableCell(withIdentifier: "GenreCellID", for: indexPath)
        
        return genreCell
        
    }
    
    //returns hieght of row for MovieList
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 100
    }
    
}
