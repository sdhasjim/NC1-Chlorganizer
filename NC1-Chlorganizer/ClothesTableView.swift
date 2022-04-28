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

class ClothesTableView: UITableViewController {
    
    var firstLoad = true
    
    func nonDeletedClothes() -> [Clothes] {
        var noDeleteClothesList = [Clothes] ()
        for clothes in clothesList {
            if (clothes.deletedDate == nil) {
                noDeleteClothesList.append(clothes)
            }
        }
        
        return noDeleteClothesList
    }
    
    override func viewDidLoad() {
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
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clothesCell = tableView.dequeueReusableCell(withIdentifier: "clothesCellID", for: indexPath) as! ClothesCell
        
        let thisClothes: Clothes!
        thisClothes = nonDeletedClothes()[indexPath.row]
        
        clothesCell.nameLabel.text = thisClothes.name
        clothesCell.storageLabel.text = thisClothes.storage
        
        return clothesCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedClothes().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editClothes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editClothes") {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let clothesDetail = segue.destination as? ViewController
            
            let selectedClothes : Clothes!
            selectedClothes = nonDeletedClothes()[indexPath.row]
            clothesDetail!.selectedClothes = selectedClothes
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
