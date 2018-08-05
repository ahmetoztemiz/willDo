//
//  CategoryTableViewController.swift
//  willDo
//
//  Created by ahmet on 3.08.2018.
//  Copyright © 2018 ahmetoztemiz. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
   
    //MARK - TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row].name
        
        cell.textLabel?.text = category
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! willDoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK - TableView Add Button
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category."
            textField = alertTextField
        }

        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data Manipulation Method
    func saveCategory(){
        do {
            try context.save()
        } catch {
            print("Error occured while saving category data. \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error occured while loading category data. \(error)")
        }
        tableView.reloadData()
    }
    
}
