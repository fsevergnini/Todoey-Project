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
    
    //obtaining filepath where data can be stored (more in intro to xcode.h) and appending a new plist to it
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
//        let item1 = ListDataModel(_itemContent: "Find Mike", _checked: false)
//
//        let item2 = ListDataModel(_itemContent: "Buy Eggos", _checked: false)
//
//        let item3 = ListDataModel(_itemContent: "Destroy Demogorgon", _checked: false)
//
//        itemArray.append(item1)
//        itemArray.append(item2)
//        itemArray.append(item3)
        loadItems()
        
    }
    
    
    //to set # of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //set properties of cells that are currently being displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //first call: when tableview gets loaded. Ad taht point, no item is loaded yet, even viewDidLoad. other calls: whenever tableView.reloadData() happens
        
        //creating cell. withIdentifier must match cell name seen in document outline
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //passing the string stored in itemArray.ItemObject.ItemContent to the cells
        cell.textLabel?.text = itemArray[indexPath.row].itemContent
        
        //defining if cells should have a checkmark or not, using ternary:
        cell.accessoryType = itemArray[indexPath.row].checked ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: - Allowing table view cells to be tapped and react
    
    //triggered when user taps at a row in table view. communicates with the delegate. Since we're using a TVC, this own class is the delegate already
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //updating checked parameter in the item objects. In tableView(cellForRowAt) checked parameter will be used to change check marks in UI
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        //saving data again, to update "checked" status in the plist
        saveItems()
        
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
            
            //conforming itemArray to the plist format and saving it in the desired directory
            self.saveItems()
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
    
    //thic fct creates an encoder, encodes itemArray and then writes it in the filepath as a p-list
    func saveItems(){
        //creating encoder object that will transform data in plist type and add it to the specified filepath
        let encoder = PropertyListEncoder()
        
        do {
            //encoding itemArray, to be written in the filepath later
            let data = try encoder.encode(self.itemArray)
            //writing data to filepath
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding array, \(error)")
        }
        
        //reloading tableview data to display new entries in list. forces tableView(cellForRowAt) to be called again
        self.tableView.reloadData()

    }
    
    func loadItems(){
        //try to find data in the filePath indicated. If it exists, load it
        if let data = try? Data(contentsOf: dataFilePath!) {
            //create the decoder object
            let decoder = PropertyListDecoder()
            
            //assign decoded data from filePath to itemArray
            do {
            itemArray = try decoder.decode([ListDataModel].self, from: data)
                //ListDataModel is the file type of the element we're trying to decode
                //from: data what will be decoded to the specified file format
            } catch {
                print("error: \(error)")
            }
        }
    }

}

