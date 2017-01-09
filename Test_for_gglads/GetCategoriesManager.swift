//
//  GetCategoriesManager.swift
//  Test_for_gglads
//
//  Created by Denis on 09.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation
import CoreData

class GetCategoriesManager
{
    class func getProductsList (context : NSManagedObjectContext, success : () -> Void , failure : (errorCode : Int) -> Void )
    {
        API_WRAPPER.getCategoriesList({ (JsonResponse) in
            
            let categoriesArray = JsonResponse["categories"].arrayValue
            
            for category in categoriesArray
            {
                let cName = category["name"].stringValue
                let cID = category["id"].int16Value
                let cColor = category["color"].stringValue
                
                CategoryFabric.createOrUpdate(withName: cName, withId: cID, withColor: cColor, withContext: context)
            }
            
            success()
            
            }) { (errorCode) in
                
        }
    }
}