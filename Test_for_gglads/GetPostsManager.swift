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
    class func getProductsList ( success : () -> Void , failure : (errorCode : Int) -> Void )
    {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.parentContext = CoreDataManager.instance.managedObjectContext
        
        GetCategoriesManager.getProductsList(privateContext, success: {
            
            API_WRAPPER.getProductList({ (JsonResponse) in
                
                let productsArray = JsonResponse["posts"].arrayValue
                
                var flag = true
                for product in productsArray
                {
                    let pID = product["id"].int64Value
                    let pName = product["name"].stringValue
                    let pLikesCount = product["votes_count"].int16Value
                    let pText = product["tagline"].stringValue
                    let pImage = product["screenshot_url"]["300px"].stringValue
                    let pRedirectURL = product["redirect_url"].stringValue
                    let pCategory = product["category_id"].int16Value
                    //                let pThumbnail = product["thumbnail"]["image_url"].stringValue
                    
                    let categoryName = Category.reciveNameOfCategory(withId: pCategory, context: privateContext)
                    
                    if flag
                    {
                        let x = "fefwefaefbhehfwehfflherfbkerjblkjbsjkdfbljkbnkjefwefaefbhehfwehfflherfbkerjblkjbsjkdfbljkbnkjrnjkn;efwefaefbhehfwehfflherfbkerjblkjbsjkdfbljkbnkjrnjkn;rnjkn;jngjkabregbkragkbskljbgjlksrbgjr"
                        ProductFabric.createOrUpdate(withProductId: pID, withProductName: pName, withProductText: x, withProductLikes: pLikesCount, withProductCategory: categoryName, withProductImage: pImage, withSelfLike: false, withProductRedirectURL: pRedirectURL, withContext: privateContext)
                    }
                    else
                    {
                        ProductFabric.createOrUpdate(withProductId: pID, withProductName: pName, withProductText: pText, withProductLikes: pLikesCount, withProductCategory: categoryName, withProductImage: pImage, withSelfLike: false, withProductRedirectURL: pRedirectURL, withContext: privateContext)
                    }
                    
                    flag = false
                }
                
                
                try? privateContext.save()
                success()
                
            }) { (errorCode) in
                
                failure(errorCode: errorCode)
            }
            
        }) { (errorCode) in
            
            failure(errorCode: 1)
            
        }
        
        
    }
}


//MARK: Показывает всплывающее вверху окно с ошибкой
extension GetPostsManager
{
    private class func showError(errorCode : Int, viewController : UIViewController, hasTopBar : Bool)
    {
        if errorCode == 0
        {
            dispatch_async(dispatch_get_main_queue(), {
                TopMessages.showMessageTop("Нет соединения с интернетом", viewController: viewController, hasTopBar: hasTopBar)
                print("Нет соединения с интернетом")
            })
        }
        
        if errorCode == 1
        {
            dispatch_async(dispatch_get_main_queue(), {
                TopMessages.showMessageTop("Превышено время запроса", viewController: viewController, hasTopBar: hasTopBar)
                print("Превышено время запроса")
            })
        }
    }
    
    private class func showError(errorCode : Int, viewController : UIViewController, hasTopBar : Bool, successBlock success : ()->Void )
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