//
//  CategoryTableViewController.swift
//  Accomplish
//
//  Created by Jacob Rozell on 10/6/19.
//  Copyright © 2019 Jacob Rozell. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    let resuse = "CategoryCell"
   
    var categoryList = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        loadCategories()
    }

    // MARK: - TableView Data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resuse, for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveCategories()
        performSegue(withIdentifier: "goToItems", sender: categoryList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.selectedCategory = sender as? Category
            destinationVC.title = (sender as? Category)?.name
        }
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, sucess) in
            self.deleteCategory(at: indexPath)
            sucess(true)
        }

        deleteAction.image = UIImage(named: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }


    // MARK: - Data Manipulation
    func createCategory(with name: String, _ isDone: Bool=false) -> Category {
        let newCategory = Category(context: context)
        newCategory.name = name
        return newCategory
    }

    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error.localizedDescription)")
        }
        tableView.reloadData()
    }

    func loadCategories(with request: NSFetchRequest<Category>=Category.fetchRequest()) {
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error.localizedDescription)")
        }
        tableView.reloadData()
    }

    func deleteCategory(at indexPath: IndexPath) {
        context.delete(categoryList[indexPath.row])
        categoryList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        saveCategories()
    }


    // MARK: - IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }

        alert.addAction(UIAlertAction(title: "Add Category", style: .default, handler: { (action) in
            if textField.text == "" {
                return
            }

            self.categoryList.append(self.createCategory(with: textField.text!))
            self.saveCategories()

            self.tableView.reloadData()
        }))
        self.present(alert, animated: true)
    }
}

