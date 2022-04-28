//
//  ClothesTableView.swift
//  NC1-Chlorganizer
//
//  Created by Samuel Dennis on 27/04/22.
//

import Foundation
import UIKit
import CoreData

var clothesList = [Clothes]()
var filteredClothes = [Clothes]()

class ClothesTableView: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    let searchController = UISearchController()
    
    var firstLoad = true
    var viewController = ViewController()
    
    func nonDeletedClothes() -> [Clothes] {
        var noDeleteClothesList = [Clothes] ()
        for clothes in clothesList {
            if (clothes.deletedDate == nil) {
                noDeleteClothesList.append(clothes)
            }
        }
        
        return noDeleteClothesList
    }
    
    func nonDeletedFilteredClothes() -> [Clothes] {
        var noDeleteFilterClothesList = [Clothes] ()
        for clothes in filteredClothes {
            if (clothes.deletedDate == nil) {
                noDeleteFilterClothesList.append(clothes)
            }
        }
        return noDeleteFilterClothesList
    }
    
    override func viewDidLoad() {
        initSearchController()
        if(firstLoad) {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let clothes = result as! Clothes
                    clothesList.append(clothes)
                }
            } catch {
                print("fetch failed")
            }
        }
    }
    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Available", "Unavailable"]
        searchController.searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All") {
        filteredClothes = clothesList.filter {
            clothes in
//            let scopeMatch = (scopeButton == "All" || clothes.name!.lowercased().contains(scopeButton.lowercased()))
            let scopeMatch = (scopeButton == "All" || clothes.statusAvailability == true)
            let scopeMatchUnavail = (scopeButton == "All" || clothes.statusAvailability == false)
            
            if scopeButton == "Available" {
                if searchController.searchBar.text != "" {
                    let searchTextMatch = clothes.name!.lowercased().contains(searchText.lowercased())
                    
                    return scopeMatch && searchTextMatch
                } else {
                    return scopeMatch
                }
            } else {
                if searchController.searchBar.text != "" {
                    let searchTextMatch = clothes.name!.lowercased().contains(searchText.lowercased())
                    
                    return scopeMatchUnavail && searchTextMatch
                } else {
                    return scopeMatchUnavail
                }
            }
        }
        tableView.reloadData()
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clothesCell = tableView.dequeueReusableCell(withIdentifier: "clothesCellID", for: indexPath) as! ClothesCell
        
        let thisClothes: Clothes!
        
        if searchController.isActive {
            thisClothes = nonDeletedFilteredClothes()[indexPath.row]
        } else {
            thisClothes = nonDeletedClothes()[indexPath.row]
        }
        
        clothesCell.nameLabel.text = thisClothes.name
        clothesCell.storageLabel.text = thisClothes.storage
        if (thisClothes.statusAvailability) {
            clothesCell.imageStatus.image = UIImage(named: "available")
        } else {
            clothesCell.imageStatus.image = UIImage(named: "unavailable")
        }
        return clothesCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return nonDeletedFilteredClothes().count
        }
        return nonDeletedClothes().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editClothes", sender: self)
    }
    
    var selectedClothes: Clothes? = nil
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
//
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
//            do {
//                let results: NSArray = try context.fetch(request) as NSArray
//                for result in results {
//                    let clothes = result as! Clothes
//                    if (clothes == selectedClothes) {
//                        clothes.deletedDate = Date()
//                        try context.save()
//                    }
//                }
//
//            } catch {
//                print("fetch failed")
//            }
//            print("deleted")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editClothes") {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let clothesDetail = segue.destination as? ViewController
            
            let selectedClothes : Clothes!
//            selectedClothes = nonDeletedClothes()[indexPath.row]
            
            if searchController.isActive {
                selectedClothes = nonDeletedFilteredClothes()[indexPath.row]
            } else {
                selectedClothes = nonDeletedClothes()[indexPath.row]
            }
            
            clothesDetail!.selectedClothes = selectedClothes
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
