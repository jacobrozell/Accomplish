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
    let key = "TodoListArray"
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item(title: "A")
        itemArray.append(newItem)
        
        let newItem2 = Item(title: "B")
        itemArray.append(newItem2)
        
        let newItem3 = Item(title: "C")
        itemArray.append(newItem3)
        
        let newItem4 = Item(title: "D")
        itemArray.append(newItem4)
        
        let newItem5 = Item(title: "E")
        itemArray.append(newItem5)
        
        let newItem6 = Item(title: "F")
        itemArray.append(newItem6)
        
        let newItem7 = Item(title: "G")
        itemArray.append(newItem7)
        
        let newItem8 = Item(title: "H")
        itemArray.append(newItem8)
        
        let newItem9 = Item(title: "I")
        itemArray.append(newItem9)
        
        let newItem10 = Item(title: "J")
        itemArray.append(newItem10)
        
        let newItem11 = Item(title: "K")
        itemArray.append(newItem11)
        
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
        
        tableView.cellForRow(at: indexPath)?.accessoryType = cellAccessoryType
        tableView.deselectRow(at: indexPath, animated: true)
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
            self.itemArray.append(Item(title: textField.text!))

            //self.defaults.set(self.items, forKey: self.key)
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true)
    }
}
