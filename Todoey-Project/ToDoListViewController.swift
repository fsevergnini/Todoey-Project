//
//  ViewController.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/12/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit

//when creating a class that inherits from UITVC, there is no need to implement the TV protocols, delegate or datasource
//the delegate is seen already as this own class
class ToDoListViewController: UITableViewController {

    //creting an array of objects of type ListDataModel
    var itemArray = [ListDataModel]()
    
    //creating constant to store values after app is terminated
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = ListDataModel(_itemContent: "Find Mike", _checked: false)
        
        let item2 = ListDataModel(_itemContent: "Buy Eggos", _checked: false)
        
        let item3 = ListDataModel(_itemContent: "Destroy Demogorgon", _checked: false)
        
        itemArray.append(item1)
        itemArray.append(item2)
        itemArray.append(item3)
//        //loading list saved in defaults. "if" statement used to make sure the defaults file exist already, or else app will break
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
    }
    
    
    //to set # of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //set properties of table view cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating cell. identifier must match cell name seen in document outline
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        
        //passing the string stored in itemArray.ItemObject.ItemContent to the cells
        cell?.textLabel?.text = itemArray[indexPath.row].itemContent
        return cell!
    }
    // MARK: - Allowing table view cells to be tapped and react
    
    //this fct communicates with the delegate. Since we're using a TVC, this own class is the delegate already
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //this constant is created to facilitate writing the if statement below
        let checkStatus = tableView.cellForRow(at: indexPath)?.accessoryType
        
        //checking / unchecking the cell
        if checkStatus == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //setting the animation to de-select an item (make the gray highlight disappear
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Designing button to add new items to list using alarms
    
    @IBAction func didAddNewItem(_ sender: Any) {
        //creating alert icon
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        //creating this variable to store the input from the alert
        //alert input is origianlly only a local var within a closure
        var userInput = UITextField()
        
        //create possible action to perform when alert is shown
        //this is called when "add item" is pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("user tapped to add item")
                //"add item" is shown in the UI
                //print is called when user taps in the action "add item"
            
            //userInput is set to receive its value in alert.addTextField, but can't pass values there, bc it will pass the value it has before receiving the user input. so instead, its value will be passed to itemArray here
            let newItem = ListDataModel(_itemContent: userInput.text!, _checked: false)
            self.itemArray.append(newItem)
            
//            //setting defaults constant to store list in a plist with key "TodoListArray"
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
//
            //reloading tableview data to display new entries in list
            self.tableView.reloadData()
            
        }
        
        //adding default grayed out message in the input box
        //only triggered when textfield is added
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            userInput = alertTextField
        }
        
        //adding the action button created to the alert
        alert.addAction(action)
        
        //presenting the alert
        present(alert, animated: true, completion: nil)
    }
    

}

