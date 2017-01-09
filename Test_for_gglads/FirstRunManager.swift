////
////  FirstRunManager.swift
////  Test_for_gglads
////
////  Created by Denis on 05.01.17.
////  Copyright © 2017 Denis. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//
//class FirstRunManager
//{
//    class func addDataToProductController() -> [Product]
//    {
//        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
//        privateContext.parentContext = CoreDataManager.instance.managedObjectContext
//        
//        for i in 1...30
//        {
//            let selfLiked = true ? i % 2 == 0 : i % 2 != 0
//            var textForProduct = ""
//            if selfLiked
//            {
//                textForProduct = "qwerqretgtdfghffdjgryejytjrtgsdfdgvdartrytiuykhmnbcbvndjytdhsdgdgfcvxcegretrhbfbdfgbrrjrfgdfgsrthrhdfghhrtshtrhsfhgbfbfbsrtbsthtrshfbfbtrtrhsrhrtrtb"
//            }
//            else
//            {
//                textForProduct = "Product \(i) is the best"
//            }
//            let product = ProductFabric.createOrUpdate(withProductId: Int64(i), withProductName: "Product \(i)", withProductText: textForProduct, withProductLikes: Int16(i), withProductCategory: "testCategory", withProductImage: "", withSelfLike: selfLiked , withContext: privateContext)
//            product?.needShowAll = false
//        }
//        
//        try? privateContext.save()
//        
//        return Product.loadToSwiftArray()
//    }
//}