//
//  ViewController.swift
//  willDo
//
//  Created by ahmet on 1.08.2018.
//  Copyright © 2018 ahmetoztemiz. All rights reserved.
//

import UIKit

class willDoTableViewController: UITableViewController{

    var items = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
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
            
            
            let newItem = Item()
            newItem.title = textField.text!
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print("While running App, error has been occured. \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("While running App, error has been occured. \(error)")
            }
        }
        
    }
    
}

