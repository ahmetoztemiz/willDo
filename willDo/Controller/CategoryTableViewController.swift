//
//  CategoryTableViewController.swift
//  willDo
//
//  Created by ahmet on 3.08.2018.
//  Copyright © 2018 ahmetoztemiz. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .singleLine
        
        loadCategory()
    }
   
    //MARK - TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categoryArray?[indexPath.row].name
        cell.textLabel?.text = category ?? "No category added yet!"
         
        return cell
    }
    
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! willDoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK - TableView Add Button
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!

            self.saveCategory(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category."
            textField = alertTextField
        }

        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data Manipulation Method
    func saveCategory(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error occured while saving category data. \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK - Deletion Method Override Function
    override func updateModel(at indexPath: IndexPath) {
        //calling super function with override method.
        super.updateModel(at: indexPath)
        
        if let currentRow = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(currentRow)
                }
            } catch {
                print("Error occured while deleting item. \(error)")
            }
        }
    }
    
}
