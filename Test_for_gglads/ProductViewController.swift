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
    weak var titleButton : TitleButton!
    
    
    var refreshControl : UIRefreshControl!
    var dataSource = [Product]()
    var categories = [Category]()
    weak var popController : CategoriesViewController!
    var backView : UIView! //when categories opened
    var selectedProduct : Product?
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
        
        
        //title button
        let button =  TitleButton()
        titleButton = button
        self.navigationItem.titleView = titleButton
        titleButton.delegate = self
        
        
        //load
        if Product.loadToSwiftArray().count == 0
        {
            Alert.instance.showLoadingAlert(atView: self.view, withNavigationController: self.navigationController)
            
            loadNewProducts(needClearData: false)
        }
        else
        {
            if let lastUpdateDate = NSUserDefaults.standardUserDefaults().objectForKey(Const.AppUserDefaults.kLastUpdateDate) as? String
            {
                if lastUpdateDate != NSDate().dateToString()
                {
                    Alert.instance.showLoadingAlert(atView: self.view, withNavigationController: self.navigationController)
                    
                    loadNewProducts(needClearData: true)
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.categories = Category.loadToSwiftArray()
                        self.titleButton.setTitle(self.categories.first?.name, forState: .Normal)
                        
                        self.dataSource = Product.loadToSwiftArray(withCategory: self.categories.first!)
                        self.tableView.reloadData()
                    })
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    self.categories = Category.loadToSwiftArray()
                    self.titleButton.setTitle(self.categories.first?.name, forState: .Normal)
                    
                    self.dataSource = Product.loadToSwiftArray(withCategory: self.categories.first!)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let model = dataSource[indexPath.row]
        
        if model.isIntresting
        {
            let notIntresting = UITableViewRowAction(style: .Normal, title: "Not intresting") { action, index in
                tableView.setEditing(false, animated: true)
                self.setModelIntresting(isIntresting: false, withModel: model, atIndexPath: indexPath)
            }
            notIntresting.backgroundColor = UIColor.redColor()
            
            return [notIntresting]
        }
        else
        {
            let intresting = UITableViewRowAction(style: .Normal, title: "Intresting") { action, index in
                tableView.setEditing(false, animated: true)
                self.setModelIntresting(isIntresting: true, withModel: model, atIndexPath: indexPath)
            }
            intresting.backgroundColor = UIColor.orangeColor()
            
            return [intresting]
        }
        
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
            
            GetPostsManager.getProductsList(needToCleanData: false, success: {
                
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


//MARK: TITLE BUTTON
extension ProductViewController : TitleButtonDelegate
{
    func openCategories()
    {
        if popController == nil
        {
            dispatch_async(dispatch_get_main_queue(), {
                self.popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("categoryView") as! CategoriesViewController
                self.addChildViewController(self.popController)
                
                let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
                let categoriesTableViewHeight = self.popController.rowHeight * CGFloat(self.categories.count)
                
                self.popController.view.frame = CGRectMake(0, -1 * (self.navigationController?.navigationBar.frame.height)! - statusBarHeight - categoriesTableViewHeight, self.view.frame.width, categoriesTableViewHeight)
                
                if self.backView == nil
                {
                    self.backView = UIView(frame: self.view.frame)
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeCategoriesByTappingBackView))
                    self.backView.addGestureRecognizer(gesture)
                }
                self.backView.backgroundColor = UIColor.clearColor()
                self.view.addSubview(self.backView)
                
                UIView.animateWithDuration(0.5) {
                    self.backView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
                    self.popController.view.frame = CGRectMake(0, (self.navigationController?.navigationBar.frame.height)! + statusBarHeight, self.view.frame.width, categoriesTableViewHeight)
                }
                
                self.popController.categoriesDataSource = self.categories
                self.popController.mainController = self
                
                self.view.addSubview(self.popController.view)
                self.popController.didMoveToParentViewController(self)
            })
        }
    }
    
    
    func closeCategories()
    {
        if popController != nil
        {
            dispatch_async(dispatch_get_main_queue(), {
                let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
                let categoriesTableViewHeight = self.popController.rowHeight * CGFloat(self.categories.count)
                
                UIView.animateWithDuration(0.5, animations: {
                    
                    self.popController.view.frame = CGRectMake(0, -1 * (self.navigationController?.navigationBar.frame.height)! - statusBarHeight - categoriesTableViewHeight, self.view.frame.width, categoriesTableViewHeight)
                    self.backView.backgroundColor = UIColor.clearColor()
                    
                    }, completion: { (hide) in
                        self.popController.removeFromParentViewController()
                        self.backView.removeFromSuperview()
                })
                
            })
            
        }
    }
    
    
    func closeCategoriesByTappingBackView()
    {
        if self.titleButton.isSelect
        {
            self.titleButton.isSelect = false
        }
    }
}


//MARK: DID SELECT CELL
extension ProductViewController
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedProduct = dataSource[indexPath.row]
        performSegueWithIdentifier("toDetail", sender: self)
    }
}


//MARK: PREPARE FOR SEGUE
extension ProductViewController
{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toDetail"
        {
            let destinationViewController = segue.destinationViewController as! DetailViewController
            destinationViewController.productModel = self.selectedProduct
        }
    }
}


//MARK: LOAD NEW PRODUCTS
extension ProductViewController
{
    func loadNewProducts(needClearData need : Bool)
    {
        GetPostsManager.getProductsList(needToCleanData: need, success: { 
            
            dispatch_async(dispatch_get_main_queue(), {
                Alert.instance.closeLoadingAlert(Alert.instance.alert)
                
                self.categories = Category.loadToSwiftArray()
                self.titleButton.setTitle(self.categories.first?.name, forState: .Normal)
                
                self.dataSource = Product.loadToSwiftArray(withCategory: self.categories.first!)
                self.tableView.reloadData()
            })
            
            }) { (errorCode) in
                
        }
    }
}


//MARK: CELL SWIPE ACTIONS
extension ProductViewController
{
    func setModelIntresting( isIntresting intresting : Bool, withModel model : Product, atIndexPath indexPath : NSIndexPath )
    {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id=%lld", model.id)
        
        do
        {
            let fetchResults = try CoreDataManager.instance.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if let fetchedProduct = fetchResults.first as? Product
            {
                if intresting
                {
                    fetchedProduct.isIntresting = true
                }
                else
                {
                    fetchedProduct.isIntresting = false
                }
                
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            }
            
        }
        catch{}
    }
}