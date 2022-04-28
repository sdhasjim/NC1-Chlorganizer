//
//  Clothes+CoreDataProperties.swift
//  NC1-Chlorganizer
//
//  Created by Samuel Dennis on 28/04/22.
//
//

import Foundation
import CoreData


extension Clothes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clothes> {
        return NSFetchRequest<Clothes>(entityName: "Clothes")
    }

    @NSManaged public var deletedDate: Date?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var storage: String?
    @NSManaged public var statusAvailability: Bool

}

extension Clothes : Identifiable {

}
