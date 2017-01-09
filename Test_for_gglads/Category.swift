//
//  Category.swift
//  
//
//  Created by Denis on 09.01.17.
//
//

import Foundation
import CoreData


class Category: NSManagedObject
{
    class func reciveNameOfCategory( withId id : Int16, context : NSManagedObjectContext ) -> String
    {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "id=%d", id)
        do
        {
            if let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Category]
            {
                return (fetchResults.first?.name)!
            }
        }
        catch{}
        
        return "Uncknown category"
    }
    
    
    class func loadToSwiftArray() -> [Category]
    {
        var arrayToReturn = [Category]()
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        do
        {
            if let fetchResults = try CoreDataManager.instance.managedObjectContext.executeFetchRequest(fetchRequest) as? [Category]
            {
                for fetchedCategory in fetchResults
                {
                    arrayToReturn.append(fetchedCategory)
                }
                
                arrayToReturn.sortInPlace({ $0.id < $1.id })
                
                return arrayToReturn
            }
        }
        catch{}
        
        return arrayToReturn
    }
}
