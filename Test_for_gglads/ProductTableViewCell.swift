//
//  ProductTableViewCell.swift
//  Test_for_gglads
//
//  Created by Denis on 05.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SDWebImage

class ProductTableViewCell: UITableViewCell
{
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productText: UILabel!
    @IBOutlet weak var productLikesLabel: UILabel!
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var showAllButton: ShowAllButton!
    @IBOutlet weak var showAllButtonTopConstraint: NSLayoutConstraint!
    
    var delegate : ProductCellDelegate?
    var cellModel : Product?    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    override func prepareForReuse()
    {
        showAllButtonTopConstraint.constant = 8
        showAllButton.alpha = 1.0
        showAllButton.enabled = true
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    func configureCell( model: Product )
    {
        cellModel = model
        
        let inset : CGFloat = 86
        separatorInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
        
        productName.text = model.productName
        productLikesLabel.text = String(model.productLikes)
        productImage.sd_setImageWithURL(NSURL(string: model.productImage!), placeholderImage: UIImage(named: "productImage"))
        
        if model.isIntresting
        {
            self.backgroundColor = Const.appColors.intrestingCellColor
        }
        
        productText.text = model.productText
        print(calculateNumberOfPrductTextLines())
        
        if model.selfLiked
        {
            likeButton.isSelect = true
        }
        else
        {
            likeButton.isSelect = false
        }
        
        if !model.needShowAll
        {
            if model.productText?.characters.count <= 78
            {
                showAllButton.alpha = 0.0
                showAllButton.enabled = false
                self.productText.text = model.productText
                showAllButton.isSelect = false
            }
            else
            {
                let txt = model.productText
                self.productText.text = txt![(txt?.startIndex.advancedBy(0))!...(txt?.startIndex.advancedBy(78))!]
                showAllButton.isSelect = false
            }
        }
        else
        {
            productText.text = model.productText
            showAllButton.isSelect = true
        }
    }
}


extension ProductTableViewCell
{
    @IBAction func showAllTapped(sender: AnyObject)
    {
        if showAllButton.isSelect
        {
            cellModel!.needShowAll = false
        }
        else
        {
            cellModel!.needShowAll = true
        }
        
        self.productText.text = cellModel?.productText
        self.layoutIfNeeded()
        delegate?.showAllTapped(self)
    }
    
    
    @IBAction func likeTapped(sender: AnyObject)
    {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id=%lld", (cellModel?.id)!)
        
        do
        {
            let fetchResults = try CoreDataManager.instance.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if let fetchedProduct = fetchResults.first as? Product
            {
                if fetchedProduct.selfLiked
                {
                    fetchedProduct.selfLiked = false
                    fetchedProduct.productLikes -= 1
                    self.productLikesLabel.text = String(fetchedProduct.productLikes)
                }
                else
                {
                    fetchedProduct.selfLiked = true
                    fetchedProduct.productLikes += 1
                    self.productLikesLabel.text = String(fetchedProduct.productLikes)
                }
            }
            
        }
        catch{}
    }
}


extension ProductTableViewCell
{
    private func calculateNumberOfPrductTextLines() -> Int
    {
        return Int((productText.intrinsicContentSize().width) / productText.frame.width)
    }
}
