//
//  GetPostsManager.swift
//  Test_for_gglads
//
//  Created by Denis on 08.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class GetPostsManager
{
    class func getProductsList ( needToCleanData need : Bool, success : () -> Void , failure : (errorCode : Int) -> Void )
    {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.parentContext = CoreDataManager.instance.managedObjectContext
        
        if need
        {
            CoreDataManager.instance.deleteProducts(privateContext)
            CoreDataManager.instance.deleteCategories(privateContext)
        }
        
        
        GetCategoriesManager.getCategoriesList(privateContext, success: {
            
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
                    
                    ProductFabric.createOrUpdate(withProductId: pID, withProductName: pName, withProductText: pText, withProductLikes: pLikesCount, withProductCategory: categoryName, withProductImage: pImage, withSelfLike: false, withProductRedirectURL: pRedirectURL, withProductThumbnail: pThumbnail, withProductDAte: pDate, withProductBigImage: pBigImage, withContext: privateContext)
                    
                }
                
                
                try? privateContext.save()
                
                let todayDate = NSDate().dateToString()
                NSUserDefaults.standardUserDefaults().setObject(todayDate, forKey: Const.AppUserDefaults.kLastUpdateDate)
                NSUserDefaults.standardUserDefaults().synchronize()
                
                success()
                
            }) { (errorCode) in
                
                failure(errorCode: errorCode)
            }
            
        }) { (errorCode) in
            
            failure(errorCode: errorCode)
            
        }
        
        
    }
}


//MARK: Показывает всплывающее вверху окно с ошибкой
extension GetPostsManager
{
    class func showError(errorCode : Int, viewController : UIViewController, hasTopBar : Bool, successBlock success : ()->Void )
    {
        if errorCode == 0
        {
            dispatch_async(dispatch_get_main_queue(), {
                TopMessages.showMessageTop("Нет соединения с интернетом", viewController: viewController, hasTopBar: hasTopBar, successBlock: {
                    success()
                })
                print("Нет соединения с интернетом")
            })
        }
        
        if errorCode == 1
        {
            dispatch_async(dispatch_get_main_queue(), {
                TopMessages.showMessageTop("Превышено время запроса", viewController: viewController, hasTopBar: hasTopBar, successBlock: {
                    success()
                })
                print("Превышено время запроса")
            })
        }
    }
}