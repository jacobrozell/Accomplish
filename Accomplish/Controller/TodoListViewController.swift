//
//  ViewController.swift
//  Accomplish
//
//  Created by Jacob Rozell on 7/15/19.
//  Copyright © 2019 Jacob Rozell. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    let reuse = "ToDoItemCell"
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        loadItems()
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
            self.itemArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveItems()
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
            self.itemArray.append(Item(title: textField.text!))
            self.saveItems()
            
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: Model Manupulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error loading items \(error)")
            }
        }
    }
}
