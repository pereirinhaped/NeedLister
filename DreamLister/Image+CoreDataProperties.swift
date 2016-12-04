//
//  Image+CoreDataProperties.swift
//  DreamLister
//
//  Created by Pedro Pereirinha on 04/12/16.
//  Copyright © 2016 EpicDory. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var toItem: Item?

}
