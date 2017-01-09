//
//  CategoryFabric.swift
//  Test_for_gglads
//
//  Created by Denis on 05.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation
import CoreData


class CategoryFabric
{
    class func createOrUpdate( withName name : String, withId id : Int16, withColor color : String, withContext context : NSManagedObjectContext) -> Category?
    {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "id=%d", id)
        
        do
        {
            let fetchResults = try context.executeFetchRequest(fetchRequest)
            
            if ( fetchResults.count == 1 )
            {
                let category = fetchResults[0] as! Category
                
                category.id = id
                category.name = name
                category.color = color
                
                return category
            }
            else if ( fetchResults.count == 0 )
            {
                let category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as! Category
                
                category.id = id
                category.name = name
                category.color = color
                
                return category
                
            }
            else
            {
                var categoryToReturn : Category?
                
                for i in 0..<fetchResults.count
                {
                    let category = fetchResults[i] as! Category
                    
                    if ( i == 0 )
                    {
                        category.id = id
                        category.name = name
                        category.color = color
                        
                        categoryToReturn = category
                    }
                    else
                    {
                        context.deleteObject(category)
                    }
                }
                
                return categoryToReturn
            }
        }
        catch
        {
            return nil
        }
    }
}