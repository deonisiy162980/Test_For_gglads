//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Denis on 09.01.17.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category
{
    @NSManaged var id: Int16
    @NSManaged var name: String?
    @NSManaged var color: String?
}
