//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Pedro Pereirinha on 04/12/16.
//  Copyright © 2016 EpicDory. All rights reserved.
//

import UIKit
import CoreData

extension String {
	func toDouble() -> Double? {
		return NumberFormatter().number(from: self)?.doubleValue
	}
}

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	@IBOutlet weak var titleTxtFld: CustomTextField!
	@IBOutlet weak var priceTxtFld: CustomTextField!
	@IBOutlet weak var detailsTxtFld: CustomTextField!
	@IBOutlet weak var storePickerView: UIPickerView!
	
	var stores = [Store]()
	var itemToEdit: Item?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		storePickerView.delegate = self
		storePickerView.dataSource = self
		
		// Clear the text from back button on NavBar
		if let topItem = self.navigationController?.navigationBar.topItem {
			topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		}
		
		// Generate store data
		// generateStoreData()
		getStores()
		
		// On view loading, if an Item is passed enter on Item Edit
		if itemToEdit != nil {
			loadItemData()
		}
		
		// Escape keyboard on screen tapping
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
			view.addGestureRecognizer(tap)
		
    }
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	// MARK: - Item Control
	
	// Save item info after creation or update
	func saveItem() {
		let item: Item!
		
		if itemToEdit == nil {
			item = Item(context: context)
		} else {
			item = itemToEdit
		}
		
		if let newTitle = titleTxtFld.text {
			item.title = newTitle
		}
		if let newPrice = priceTxtFld.text?.toDouble() {
			item.price = newPrice
		}
		if let newDetails = detailsTxtFld.text {
			item.details = newDetails
		}
		item.toStore = stores[storePickerView.selectedRow(inComponent: 0)]
		
		ad.saveContext()
	}
	
	// Load item data
	func loadItemData() {
		if let item = itemToEdit {
			titleTxtFld.text = item.title
			priceTxtFld.text = "\(item.price)"
			detailsTxtFld.text = item.details
			
			// Get the correct store row
			if let store = item.toStore {
				var i = 0
				repeat {
					let s = stores[i]
					if s.name == store.name {
						storePickerView.selectRow(i, inComponent: 0, animated: false)
						break
					}
					i += 1
				} while (i < stores.count)
			}
		}
	}
	
	// Delete existing item
	func deleteItem() {
		if itemToEdit != nil {
			context.delete(itemToEdit!)
			ad.saveContext()
		}
	}
	
	// MARK: - UIPickerView Delegate and Datasource functions
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let store = stores[row]
		return store.name
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return stores.count
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// Update when selected
	}
	
	// MARK: - Button Actions
	
	@IBAction func onNewImgPress(_ sender: UIButton) {
	}
	
	@IBAction func onSaveItemPress(_ sender: UIButton) {
		saveItem()
		_ = navigationController?.popViewController(animated: true)
	}
	@IBAction func onItemDeletePress(_ sender: UIBarButtonItem) {
		deleteItem()
		_ = navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Fetch Request for stores
	
	func getStores() {
		let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
		let nameSort = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [nameSort]
		
		do {
			self.stores = try context.fetch(fetchRequest)
			self.storePickerView.reloadAllComponents()
		} catch {
			let error = error as NSError
			print("\(error)")
		}
	}
	
	
	// MARK: - TEST DATA FOR STORE ARRAY
	
	func clearStoreData() {
		// Delete Store info
	}
	
	func generateStoreData() {
		let store = Store(context: context)
		store.name = "Amazon"
		
		let store1 = Store(context: context)
		store1.name = "Apple"
		
		let store2 = Store(context: context)
		store2.name = "Bang&Olufsen"
		
		let store3 = Store(context: context)
		store3.name = "eBay"
		
		let store4 = Store(context: context)
		store4.name = "Fnac"
		
		let store5 = Store(context: context)
		store5.name = "Triumph"
		
		ad.saveContext()
	}
}
