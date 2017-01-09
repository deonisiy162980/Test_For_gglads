//
//  Product+CoreDataProperties.swift
//  Test_for_gglads
//
//  Created by Denis on 08.01.17.
//  Copyright © 2017 Denis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Product
{
    @NSManaged var category: String?
    @NSManaged var id: Int64
    @NSManaged var productImage: String?
    @NSManaged var productLikes: Int16
    @NSManaged var productName: String?
    @NSManaged var productText: String?
    @NSManaged var selfLiked: Bool
    @NSManaged var needShowAll: Bool
    @NSManaged var redirectURL: String?
}
