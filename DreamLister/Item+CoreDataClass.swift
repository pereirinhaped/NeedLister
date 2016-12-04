//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Pedro Pereirinha on 04/12/16.
//  Copyright © 2016 EpicDory. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
	
	public override func awakeFromInsert() {
		super.awakeFromInsert()
		
		// Get a current timeStamp whenever an Item is created
		self.createdOn = NSDate()
	}
}
