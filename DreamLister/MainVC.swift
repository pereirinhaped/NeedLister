//
//  ViewController.swift
//  DreamLister
//
//  Created by Pedro Pereirinha on 03/12/16.
//  Copyright © 2016 EpicDory. All rights reserved.
//

import UIKit
import CoreData

//extension UIViewController {
//	func hideKeyboardWhenTappedAround() {
//		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//		view.addGestureRecognizer(tap)
//	}
//	
//	func dismissKeyboard() {
//		view.endEditing(true)
//	}
//}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
	
	@IBOutlet weak var needListTableView: UITableView!
	@IBOutlet weak var segmentSorter: UISegmentedControl!
	
	var controller: NSFetchedResultsController<Item>!

	override func viewDidLoad() {
		super.viewDidLoad()
		//self.hideKeyboardWhenTappedAround()
		
		// TableView Delegate and DataSource
		needListTableView.delegate = self
		needListTableView.dataSource = self
		
		//generateTestData()
		attemptFetch()
	}
	
	// MARK: - TableView Delegate and DataSource functions
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = needListTableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
		
		configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
		
		return cell
	}
	
	func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
		let item = controller.object(at: indexPath as IndexPath)
		cell.configureCell(item: item)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = controller.sections {
			let sectionInfo = sections[section]
			return sectionInfo.numberOfObjects
		}
		return 0
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if let sections = controller.sections {
			return sections.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Check if there are objects in the list
		if let objs = controller.fetchedObjects, objs.count > 0 {
			let item = objs[indexPath.row]
			performSegue(withIdentifier: "ItemDetailsVC", sender: item)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ItemDetailsVC" {
			if let destination = segue.destination as? ItemDetailsVC {
				if let item = sender as? Item {
					destination.itemToEdit = item
				}
			}
		}
	}
	
	// MARK: - NSFetchResultController
	func attemptFetch() {
		let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
		
		// SortTypes
		let dateSort = NSSortDescriptor(key: "createdOn", ascending: false)
		let priceSort = NSSortDescriptor(key: "price", ascending: true)
		let titleSort = NSSortDescriptor(key: "title", ascending: true)
		
		switch(segmentSorter.selectedSegmentIndex) {
		case 0:
			fetchRequest.sortDescriptors = [dateSort]
			break
		case 1:
			fetchRequest.sortDescriptors = [priceSort]
			break
		case 2:
			fetchRequest.sortDescriptors = [titleSort]
			break
		default:
			fetchRequest.sortDescriptors = [dateSort]
		}
		
		
		let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = self
		
		self.controller = controller
		
		do {
			try controller.performFetch()
		} catch {
			let error = error as NSError
			print("\(error)")
		}
	}
	
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		needListTableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		needListTableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		switch (type) {
		case.insert:
			if let indexPath = newIndexPath {
				needListTableView.insertRows(at: [indexPath], with: .fade)
			}
			break
		case.delete:
			if let indexPath = indexPath {
				needListTableView.deleteRows(at: [indexPath], with: .fade)
			}
			break
		case.update:
			if let indexPath = indexPath {
				let cell = needListTableView.cellForRow(at: indexPath) as! ItemCell
				configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
			}
			break
		case.move:
			if let indexPath = indexPath {
				needListTableView.deleteRows(at: [indexPath], with: .fade)
			}
			if let indexPath = newIndexPath {
				needListTableView.insertRows(at: [indexPath], with: .fade)
			}
			break
		}
	}
	
	// MARK: - Sort Segment control
	@IBAction func updateSortType(_ sender: UISegmentedControl) {
		attemptFetch()
		needListTableView.reloadData()
	}
	
	
	// MARK: - TEST DATA GENERATOR
	func generateTestData() {
		
		let item = Item(context: context)
		item.title = "MacBook Pro 15"
		item.price = 2800.00
		item.details = "Intel Core i7 quad-core a 2,7 GHz, 16 GB RAM, 512 SSD and some random specs"
		
		let item2 = Item(context: context)
		item2.title = "MacBook Pro 15"
		item2.price = 2800.00
		item2.details = "Intel Core i7 quad-core a 2,7 GHz, 16 GB RAM, 512 SSD and some random specs"
		
		let item3 = Item(context: context)
		item3.title = "MacBook Pro 15"
		item3.price = 2800.00
		item3.details = "Intel Core i7 quad-core a 2,7 GHz, 16 GB RAM, 512 SSD and some random specs"
		
		ad.saveContext()
	}
}

