//
//  BackGroundFetchManager.swift
//  Test_for_gglads
//
//  Created by Denis on 10.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class BackgroundFetchManager
{
    class func getUpdates( complection : ()->Void, failure : (errorCode : Int)->Void )
    {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.parentContext = CoreDataManager.instance.managedObjectContext
        
        let loadedPosts = Product.loadToSwiftArray()
        var newPosts = [Product]()
        
        if let lastUpdateDate = NSUserDefaults.standardUserDefaults().objectForKey(Const.AppUserDefaults.kLastUpdateDate) as? String
        {
            if lastUpdateDate != NSDate().dateToString()
            {
                CoreDataManager.instance.deleteProducts(privateContext)
                CoreDataManager.instance.deleteCategories(privateContext)
            }
        }
        
        API_WRAPPER.getProductList({ (JsonResponse) in
            
            let productsArray = JsonResponse["posts"].arrayValue
            
            for product in productsArray
            {
                let pID = product["id"].int64Value
                let pName = product["name"].stringValue
                let pLikesCount = product["votes_count"].int16Value
                let pText = product["tagline"].stringValue
                let pImage = product["screenshot_url"]["300px"].stringValue
                let pRedirectURL = product["redirect_url"].stringValue
                let pCategory = product["category_id"].int16Value
                let pThumbnail = product["thumbnail"]["image_url"].stringValue
                let pDate = product["day"].stringValue
                let pBigImage = product["screenshot_url"]["850px"].stringValue
                
                let categoryName = Category.reciveNameOfCategory(withId: pCategory, context: privateContext)
                
                let recivedProduct = ProductFabric.createOrUpdate(withProductId: pID, withProductName: pName, withProductText: pText, withProductLikes: pLikesCount, withProductCategory: categoryName, withProductImage: pImage, withSelfLike: false, withProductRedirectURL: pRedirectURL, withProductThumbnail: pThumbnail, withProductDAte: pDate, withProductBigImage: pBigImage, withContext: privateContext)
                
                if !Product.arrayContains(thisProduct: recivedProduct!, inThisArray: loadedPosts)
                {
                    newPosts.append(recivedProduct!)
                }
            }
            
            if newPosts.count != 0
            {
                if newPosts.count == 1
                {
                    LocalNotificationsManager.sendNotification(withTitle: (newPosts.first?.productName)!, withBody: (newPosts.first?.productText)!)
                }
                else
                {
                    LocalNotificationsManager.sendNotification(withTitle: "Обновлено", withBody: "Доступно \(newPosts.count) новых продукта!")
                }
            }
            else
            {
                failure(errorCode: 0)
                return
            }
            
            complection()
            
            }) { (errorCode) in
                failure(errorCode: 1)
        }
    }
}