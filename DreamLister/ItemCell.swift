//
//  ItemCell.swift
//  DreamLister
//
//  Created by Pedro Pereirinha on 04/12/16.
//  Copyright © 2016 EpicDory. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
	
	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var itemTitle: UILabel!
	@IBOutlet weak var itemPrice: UILabel!
	@IBOutlet weak var itemDetails: UILabel!
	
	func configureCell(item: Item) {
		// itemImage.image = item.toImage
		itemTitle.text = item.title
		itemPrice.text = "\(item.price) €"
		itemDetails.text = item.details
		itemImage.image = item.toImage?.image as? UIImage
	}
	
}
