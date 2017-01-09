//
//  Product.swift
//  Test_for_gglads
//
//  Created by Denis on 05.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation
import CoreData


class Product: NSManagedObject
{
    class func loadToSwiftArray() -> [Product]
    {
        var arrayToReturn = [Product]()
        
        let fetchRequest = NSFetchRequest(entityName: "Product")
        do
        {
            if let fetchResults = try CoreDataManager.instance.managedObjectContext.executeFetchRequest(fetchRequest) as? [Product]
            {
                for fetchedProduct in fetchResults
                {
                    arrayToReturn.append(fetchedProduct)
                }
                
                arrayToReturn.sortInPlace({ $0.id < $1.id })
                
                return arrayToReturn
            }
        }
        catch{}
        
        return arrayToReturn
    }
    
}
