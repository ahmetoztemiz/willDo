//
//  ViewController.swift
//  willDo
//
//  Created by ahmet on 1.08.2018.
//  Copyright © 2018 ahmetoztemiz. All rights reserved.
//

import UIKit
import CoreData

class willDoTableViewController: UITableViewController{

    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        loadData()
    }
    
    //MARK - TableView Datasource Model
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WillDoItemCell", for: indexPath)
       
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//      Ternary Operator
//      value  = condition ? valueIfTrue : valueIf False
        cell.accessoryType = item.check == true ? .checkmark: .none
       
//        long way
//        if item.check == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }

        return cell
    }

    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].check = !items[indexPath.row].check
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
    }
    
    //MARK - TableView Add Button
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add willDo item.", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.check = false
            self.items.append(newItem)
            
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new willDo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(){
        do{
            try context.save()
        } catch {
            print("Error occured saving context. \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            items = try context.fetch(request)
        } catch {
            print("Error occured fetching data. \(error)")
        }
    
    }
    
}

