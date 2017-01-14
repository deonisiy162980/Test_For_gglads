//
//  ViewController.swift
//  Test_for_gglads
//
//  Created by Denis on 05.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
import CoreData
import UIColor_Hex_Swift


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
    var checkedCategory : Category!
    var needToCleanDateWithFirstResponse = false
}


//MARK: VIEW LOADS
extension ProductViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //register nib for tableView
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
        if dataSource.count == 0
        {
            Alert.instance.showLoadingAlert(atView: self.view, withNavigationController: self.navigationController)
            
            if needToCleanDateWithFirstResponse
            {
                loadNewProducts(withCategory: nil, needClearData: true, success:  nil)
                needToCleanDateWithFirstResponse = false
            }
            else
            {
                loadNewProducts(withCategory: nil, needClearData: false, success:  nil)
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), {
                self.titleButton.setTitle(withHexColor: (self.checkedCategory.color)!, withTitle: self.checkedCategory.name, forState: .Normal)
                self.navigationController?.navigationBar.tintColor = UIColor(rgba: self.checkedCategory.color!)
                
                self.dataSource = Product.loadToSwiftArray(withCategory: self.checkedCategory)
                self.tableView.reloadData()
            })
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
            
            if let lastUpdateDate = NSUserDefaults.standardUserDefaults().objectForKey(Const.AppUserDefaults.kLastUpdateDate) as? String
            {
                if lastUpdateDate != NSDate().dateToString()
                {
                    self.loadNewProducts(withCategory: self.checkedCategory, needClearData: true, success: {
                        refreshEnd()
                    })
                }
                else
                {
                    self.loadNewProducts(withCategory: self.checkedCategory, needClearData: false, success: {
                        refreshEnd()
                    })
                }
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
    func loadNewProducts(withCategory category : Category?, needClearData need : Bool, success : (()->Void)?)
    {
        GetPostsManager.getProductsList(needToCleanData: need, success: { 
            
            dispatch_async(dispatch_get_main_queue(), {
                Alert.instance.closeLoadingAlert()
                
                self.categories = Category.loadToSwiftArray()
                if category == nil
                {
                    self.checkedCategory = self.categories.first!
                }
                self.titleButton.setTitle("", forState: .Normal)
                self.titleButton.setTitle(withHexColor: (self.checkedCategory.color)!, withTitle: self.checkedCategory.name, forState: .Normal)
                self.navigationController?.navigationBar.tintColor = UIColor(rgba: self.checkedCategory.color!)
                
                if category == nil
                {
                    self.dataSource = Product.loadToSwiftArray(withCategory: self.checkedCategory)
                }
                else
                {
                    self.dataSource = Product.loadToSwiftArray(withCategory: category!)
                }
                self.tableView.reloadData()
                
                if success != nil
                {
                    success!()
                }
            })
            
            }) { (errorCode) in
                GetPostsManager.showError(errorCode, viewController: self, hasTopBar: true, successBlock: { 
                    Alert.instance.closeLoadingAlert()
                    if success != nil
                    {
                        success!()
                    }
                })
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