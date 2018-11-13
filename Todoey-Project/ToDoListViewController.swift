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

    let itemArray = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //to set # of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //set properties of table view cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating cell. identifier must match cell name seen in document outline
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")

        cell?.textLabel?.text = itemArray[indexPath.row]
        return cell!
    }
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //this fct communicates with the delegate. Since we're using a TVC, this own class is the delegate already
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
}

