//
//  ViewController.swift
//  Test_for_gglads
//
//  Created by Denis on 05.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
import CoreData


private let ProductCell = "ProductCell"
var category = "testCategory"

class ProductViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
//    var objectsFromCoreData : [Product] {
//        return Product.loadToSwiftArray()
//    }
    var refreshControl : UIRefreshControl!
    var dataSource = [Product]()
}


//MARK: VIEW LOADS
extension ProductViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //register nibb for tableView
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: ProductCell)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = .clearColor()
        tableView.addSubview(refreshControl)
        
        if Product.loadToSwiftArray().count == 0
        {
            Alert.instance.showLoadingAlert(atView: self.view, withNavigationController: self.navigationController)
            
            GetPostsManager.getProductsList({
                
                dispatch_async(dispatch_get_main_queue(), {
                    Alert.instance.closeLoadingAlert(Alert.instance.alert)
                    self.dataSource = Product.loadToSwiftArray()
                    self.tableView.reloadData()
                })
                
                
            }) { (errorCode) in
                
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), {
                self.dataSource = Product.loadToSwiftArray()
                self.tableView.reloadData()
            })
        }
    }
    
    
}


//MARK: TABLE VIEW DELEGATE
extension ProductViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let model = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(ProductCell, forIndexPath: indexPath) as! ProductTableViewCell
        
        cell.delegate = self
        cell.configureCell(model)
        
        return cell
    }
}


//MARK: PRODUCT CELL DELEGATE
extension ProductViewController: ProductCellDelegate
{
    func showAllTapped(cellModel: ProductTableViewCell)
    {
        if let indexPath = self.tableView.indexPathForCell(cellModel)
        {
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle , animated: true)
        }
    }
}


//MARK: REFRESH
extension ProductViewController
{
    func refresh()
    {
        refreshBegin {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    
    func refreshBegin(refreshEnd:() -> ())
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            GetPostsManager.getProductsList({
                
                dispatch_async(dispatch_get_main_queue(), {
                    Alert.instance.closeLoadingAlert(Alert.instance.alert)
                    self.dataSource = Product.loadToSwiftArray()
                    self.tableView.reloadData()
                    refreshEnd()
                })
                
                
            }) { (errorCode) in
                
            }
            
        })
    }
}