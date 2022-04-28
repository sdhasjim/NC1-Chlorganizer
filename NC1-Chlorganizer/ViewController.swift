//
//  ViewController.swift
//  NC1-Chlorganizer
//
//  Created by Samuel Dennis on 27/04/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var storageTextField: UITextField!
    @IBOutlet weak var statusToggleSwitch: UISwitch!
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedClothes: Clothes? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.alpha = 0
        if (selectedClothes != nil) {
            deleteButton.alpha = 1
            nameTextField.text = selectedClothes?.name
            storageTextField.text = selectedClothes?.storage
            statusToggleSwitch.isOn = selectedClothes!.statusAvailability
//            statusToggleSwitch.isOn = ((selectedClothes?.statusAvailability) != nil)
//            statusToggle.isEnabled = selectedClothes?.statusAvailability
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if (selectedClothes == nil) {
            let entity = NSEntityDescription.entity(forEntityName: "Clothes", in: context)
            let newClothes = Clothes(entity: entity!, insertInto: context)
            newClothes.id = Int32(clothesList.count)
            newClothes.name = nameTextField.text
            newClothes.storage = storageTextField.text
            newClothes.statusAvailability = statusToggleSwitch.isOn
//            if statusToggle.isOn == true {
//                newClothes.statusAvailability = "available"
//            }
//            else if statusToggle.isOn == false {
//                newClothes.statusAvailability = "unavailable"
//            }

            do {
                try context.save()
                clothesList.append(newClothes)
                navigationController?.popViewController(animated: true)

            } catch {
                print("context saved error")
            }
        }
        else { //edit
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let clothes = result as! Clothes
                    if (clothes == selectedClothes) {
                        clothes.name = nameTextField.text
                        clothes.storage = storageTextField.text
                        clothes.statusAvailability = statusToggleSwitch.isOn
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("fetch failed")
            }
        }

    }
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let clothes = result as! Clothes
                if (clothes == selectedClothes) {
                    clothes.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        } catch {
            print("fetch failed")
        }
    }
    
    
}

