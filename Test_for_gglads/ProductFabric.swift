//
//  ProductFabric.swift
//  Test_for_gglads
//
//  Created by Denis on 05.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation
import CoreData


class ProductFabric
{
    class func createOrUpdate( withProductId id : Int64,
                               withProductName name : String,
                               withProductText text: String,
                               withProductLikes likes : Int16,
                               withProductCategory category : Int16,
                               withProductImage image : String?,
                               withSelfLike selfLike : Bool,
                               withProductRedirectURL redirectURL: String?,
                               withContext context : NSManagedObjectContext
                             ) -> Product?
    {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id=%lld", id)
        
        do
        {
            let fetchResults = try context.executeFetchRequest(fetchRequest)
            
            if ( fetchResults.count == 1 )
            {
                let product = fetchResults[0] as! Product
                
                product.id = id
                product.productName = name
                product.productText = text
                product.productLikes = likes
                product.category = category
                product.productImage = image
                product.redirectURL = redirectURL
                
                return product
            }
            else if ( fetchResults.count == 0 )
            {
                let product = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: context) as! Product
                
                product.id = id
                product.productName = name
                product.productText = text
                product.productLikes = likes
                product.category = category
                product.productImage = image
                product.redirectURL = redirectURL
                product.selfLiked = selfLike
                
                return product
                
            }
            else
            {
                var productToReturn : Product?
                
                for i in 0..<fetchResults.count
                {
                    let product = fetchResults[i] as! Product
                    
                    if ( i == 0 )
                    {
                        product.id = id
                        product.productName = name
                        product.productText = text
                        product.productLikes = likes
                        product.category = category
                        product.productImage = image
                        product.redirectURL = redirectURL
                        
                        productToReturn = product
                    }
                    else
                    {
                        context.deleteObject(product)
                    }
                }
                
                return productToReturn
            }
        }
        catch
        {
            return nil
        }
    }
}