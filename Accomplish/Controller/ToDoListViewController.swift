//
//  ViewController.swift
//  Accomplish
//
//  Created by Jacob Rozell on 7/15/19.
//  Copyright © 2019 Jacob Rozell. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    let reuse = "ToDoItemCell"
    var itemArray = [Item]()
    var filteredArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
    }
    
    // MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse, for: indexPath)
        let cellAccessoryType: UITableViewCell.AccessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = cellAccessoryType
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    // MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellAccessoryType: UITableViewCell.AccessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        
        itemArray[indexPath.row].done.toggle()
        saveItems()
        
        tableView.cellForRow(at: indexPath)?.accessoryType = cellAccessoryType
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, sucess) in
            self.deleteItem(at: indexPath)
            sucess(true)
        }
        
        deleteAction.image = UIImage(named: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            if textField.text == "" {
                return
            }
    
            self.itemArray.append(self.createItem(with: textField.text!))
            self.saveItems()
            
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: Model Manupulation Methods
    func createItem(with title: String, _ isDone: Bool=false) -> Item {
        let newItem = Item(context: self.context)
        newItem.title = title
        newItem.done = isDone
        newItem.parentCategory = selectedCategory
        return newItem
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item>=Item.fetchRequest(), predicate: NSPredicate?=nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func deleteItem(at indexPath: IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        saveItems()
    }
}

// MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: titlePredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
