//
//  HasReadArticle+CoreDataProperties.swift
//  AppTest
//
//  Created by rachel ng on 08/07/2019.
//  Copyright © 2019 rachelng. All rights reserved.
//
//

import Foundation
import CoreData


extension HasReadArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HasReadArticle> {
        return NSFetchRequest<HasReadArticle>(entityName: "HasReadArticle")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?

}
