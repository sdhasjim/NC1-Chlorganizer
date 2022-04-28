//
//  Clothes.swift
//  NC1-Chlorganizer
//
//  Created by Samuel Dennis on 27/04/22.
//

import Foundation
import CoreData

@objc(Clothes)
class Clothes: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var storage: String!
    @NSManaged var deletedDate: Date!
}
