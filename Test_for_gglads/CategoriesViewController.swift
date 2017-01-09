//
//  CategoriesViewController.swift
//  Test_for_gglads
//
//  Created by Denis on 09.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    weak var mainController : ProductViewController!
    
    var categoriesDataSource = [Category]()
    var rowHeight : CGFloat = 40.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if categoriesDataSource.count > 15
        {
            tableView.scrollEnabled = true
        }
        else
        {
            tableView.scrollEnabled = false
        }
        
        tableView.rowHeight = rowHeight
        tableView.reloadData()
    }
}


//MARK: TABLE VIEW DELEGATE
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categoriesDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
        var isSelected = false
        if categoriesDataSource[indexPath.row].name == mainController.titleButton.titleLabel?.text
        {
            isSelected = true
        }
        
        cell.configureCell(withCategory: categoriesDataSource[indexPath.row], isSelected: isSelected)
        return cell
    }
}


//MARK: DID SELECT CELL
extension CategoriesViewController
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedCategory = categoriesDataSource[indexPath.row]
        
        mainController.titleButton.setTitle(selectedCategory.name, forState: .Normal)
        
        self.tableView.reloadData()
        
        mainController.dataSource = Product.loadToSwiftArray(withCategory: selectedCategory)
        mainController.tableView.reloadData()
        
        mainController.closeCategoriesByTappingBackView()
    }
}
