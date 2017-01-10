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
    
    var productModel : Product?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        productImage.sd_setImageWithURL(NSURL(string: (productModel?.productImage)!), placeholderImage: UIImage(named: "productImage"))
        productText.text = productModel?.productText
        productName.text = productModel?.productName
        likesCount.text = String(productModel!.productLikes)
        
        if productModel!.selfLiked
        {
            likeButton.isSelect = true
        }
        else
        {
            likeButton.isSelect = false
        }
    }
    
    
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
}
