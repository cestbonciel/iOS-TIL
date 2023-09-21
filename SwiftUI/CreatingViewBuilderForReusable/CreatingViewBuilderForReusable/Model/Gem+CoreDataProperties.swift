//
//  Gem+CoreDataProperties.swift
//  CreatingViewBuilderForReusable
//
//  Created by Seohyun Kim on 2023/09/16.
//
//

import Foundation
import CoreData


extension Gem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gem> {
        return NSFetchRequest<Gem>(entityName: "Gem")
    }

    @NSManaged public var crystalSystem: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var formula: String?
    @NSManaged public var hardness: String?
    @NSManaged public var info: String?
    @NSManaged public var mainColor: String?
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var transparency: String?

}

extension Gem : Identifiable {

}
