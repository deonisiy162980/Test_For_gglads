//
//  DetailViewController.swift
//  Test_for_gglads
//
//  Created by Denis on 10.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class DetailViewController: UIViewController
{
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productText: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var imageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var intrestingButton: StarButton!
    @IBOutlet weak var getItButton: UIButton!
    
    var productModel : Product?
    var defaultNavigationControllerTintColor : UIColor!
    var bigImage : UIImageView!
    var backView : UIView!
    var animation : CABasicAnimation!
    var loadingIndicator : UIActivityIndicatorView!
    
}


//MARK: VIEW LOADS
extension DetailViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        productImage.sd_setImageWithURL(NSURL(string: (productModel?.productImage)!), placeholderImage: UIImage(named: "productImage"))
        productText.text = productModel?.productText
        productName.text = productModel?.productName
        likesCount.text = String(productModel!.productLikes)
        getItButton.backgroundColor = self.navigationController?.navigationBar.tintColor
        
        if productModel!.selfLiked
        {
            likeButton.isSelect = true
        }
        else
        {
            likeButton.isSelect = false
        }
        
        if productModel!.isIntresting
        {
            intrestingButton.isSelect = true
        }
        else
        {
            intrestingButton.isSelect = false
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.openBigPhoto))
        productImage.addGestureRecognizer(gesture)
    }
}

    
//MARK: IB ACTIONS
extension DetailViewController
{
    @IBAction func getItTapped(sender: AnyObject)
    {
        UIApplication.sharedApplication().openURL(NSURL(string: productModel!.redirectURL!)!)
    }
    
    
    @IBAction func likeTapped(sender: AnyObject)
    {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id=%lld", (productModel?.id)!)
        
        do
        {
            let fetchResults = try CoreDataManager.instance.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if let fetchedProduct = fetchResults.first as? Product
            {
                if fetchedProduct.selfLiked
                {
                    fetchedProduct.selfLiked = false
                    fetchedProduct.productLikes -= 1
                    likesCount.text = String(fetchedProduct.productLikes)
                }
                else
                {
                    fetchedProduct.selfLiked = true
                    fetchedProduct.productLikes += 1
                    likesCount.text = String(fetchedProduct.productLikes)
                }
            }
            
        }
        catch{}
    }
    
    
    @IBAction func intrestingButtonTapped(sender: AnyObject)
    {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id=%lld", productModel!.id)
        
        do
        {
            let fetchResults = try CoreDataManager.instance.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if let fetchedProduct = fetchResults.first as? Product
            {
                if productModel!.isIntresting
                {
                    fetchedProduct.isIntresting = false
                }
                else
                {
                    fetchedProduct.isIntresting = true
                }
            }
            
        }
        catch{}
    }
}


//MARK: OPEN PHOTO
extension DetailViewController
{
    func openBigPhoto()
    {
        if bigImage == nil && backView == nil
        {
            let view = UIView(frame: self.view.frame)
            backView = view
            backView.backgroundColor = UIColor.clearColor()
            let gesture = UITapGestureRecognizer(target: self, action: #selector(closeBigPhoto))
            backView.addGestureRecognizer(gesture)
            self.view.addSubview(backView)
            
            let image = UIImageView(frame: productImage.frame)
            
            bigImage = image
            bigImage.layer.cornerRadius = productImage.layer.cornerRadius
            bigImage.clipsToBounds = true
            bigImage.sd_setImageWithURL(NSURL(string: (productModel?.productImage)!), placeholderImage: productImage.image)
            self.view.addSubview(bigImage)
            
            let loadIndicator = UIActivityIndicatorView(frame: CGRectMake(bigImage.frame.width / 2, bigImage.frame.height / 2, 0, 0))
            loadingIndicator = loadIndicator
            loadingIndicator.hidesWhenStopped = true
            bigImage.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
            
            let newImage = UIImageView()
            newImage.sd_setImageWithURL(NSURL(string: (productModel?.productBigImage)!), placeholderImage: productImage.image, completed: { (image, error, cache, url) in
                
                if let _ = self.bigImage
                {
                    self.bigImage.image = newImage.image
                    self.loadingIndicator.stopAnimating()
                }
            })
            
            productImage.alpha = 0.0
            
            UIView.animateWithDuration(0.4, animations: {
                let imageSize : CGFloat = self.view.frame.height / 2.0
                self.bigImage.layer.cornerRadius = imageSize / 12
                let screenHeightCenter = self.view.frame.height / 2
                self.bigImage.frame = CGRectMake(0, screenHeightCenter - imageSize / 2, self.view.frame.width, imageSize)
                self.loadingIndicator.frame = CGRectMake(self.bigImage.frame.width / 2, self.bigImage.frame.height / 2, 0, 0)
                self.backView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            })
        }
    }
    
    
    func closeBigPhoto()
    {
        if bigImage != nil && backView != nil
        {
            UIView.animateWithDuration(0.4, animations: {
                self.bigImage.layer.cornerRadius = self.productImage.layer.cornerRadius
                self.bigImage.frame = self.productImage.frame
                self.loadingIndicator.frame = CGRectMake(self.bigImage.frame.width / 2, self.bigImage.frame.height / 2, 0, 0)
                self.backView.backgroundColor = UIColor.clearColor()
                self.loadingIndicator.alpha = 0.0
            }) { (done) in
                
                self.productImage.alpha = 1.0
                self.loadingIndicator.removeFromSuperview()
                self.bigImage.removeFromSuperview()
                self.backView.removeFromSuperview()
                
                self.loadingIndicator = nil
                self.bigImage = nil
                self.backView = nil
            }
        }
    }
}
