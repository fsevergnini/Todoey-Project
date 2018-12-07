//
//  CategoryViewController.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/16/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    //MARK: - view functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#00c2ff")
    }
    
    //MARK: - Global variables for CategoryViewController
    
    //initializign realm to store data
    let realm = try! Realm()
    
    //creating array of objects of type Results, which comes from realm and is auto-updating
    var listArray: Results<Category>?
    
    //MARK: - Configuring the tableview
    
    //number of rows in tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray?.count ?? 1
    }
    
    //cells currently being displayed. This is loaded when info needs to be retrieved from database or when user taps to create new list
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //first call: before viewDidLoad. Other calls when reloadData() is used
        
        //using a cell that inherits from superclass SwipeTableVC. "super" triggers code to go to cellForRowAt in super class. This will receive the "return cell" declared in super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //adding a label indicating there are no lists created
        cell.textLabel?.text = listArray?[indexPath.row].listName ?? "No lists added yet"
        
        //adding background color. If there is no color info in listArray, it will add a random color
        cell.backgroundColor = UIColor(hexString: listArray?[indexPath.row].categoryColorHex ?? UIColor.randomFlat.hexValue())
        
        return cell
    }

    
    //MARK: - Creating a new list by pressing "add" in top right corner
    @IBAction func addButtonPressed(_ sender: Any) {
        //defining alert that will allow user to input name of new list
        
        //creating alert message for user to type new list name
        let alert = UIAlertController(title: "Create new list", message: "", preferredStyle: .alert)
        
        var userInput = UITextField()
        
        //handling input from user in the alert box
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            print("user tapped to create new list")
            //newList variable will be used to save user input in database using realm
            let newList = Category()
            
            if let inputFromUser = userInput.text {
                newList.listName = inputFromUser
                
                //assigning a random color code to newList, which will be loaded to the cell later
                newList.categoryColorHex = self.assignRandomColor()
            }
            
            self.saveLists(with: newList)
        }
        
        
        //default grayed out message in alert box
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "List"
            userInput = alertTextField
        }
        
        //adding action to alert
        alert.addAction(action)
        
        //presenting alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Saving, loading, deleting items
    func saveLists(with newList: Category){
        //save data to realm now, allow saveLists to have an input
        do {
            try realm.write {
                realm.add(newList)
            }
        } catch {
            print("error saving list: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadLists(){
        //loading all data that is a Category() object
        listArray = realm.objects(Category.self)
            //this returns a data type called "Results", which is auto-updating container
    }
    
    
    //deleting item in realm database
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                self.realm.delete(self.listArray![indexPath.row])
            }} catch {
                print("error at editActionsForRowAt: \(error)")
        }
    }
    
    //MARK: - Tableview Delegate methods - what happens when we click in one of the cells
    
    //what happens when user selects an item in root list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
        
        //by adding deselectRow, the row selected doesn't stay grayed out forever. Otherwise, when going back to list menu, the chosen list is gray instead of having its original color
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //preparing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //setting an object of ToDoListVC type
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = listArray?[indexPath.row]
            
        }
    }
    
    //randomly returns the hexadecimal value corresponding to one of the light flat colors from Chameleon Framework
    func assignRandomColor() -> String {
        
        //array containing the fla colors
        let randomColorVector = [UIColor.flatRed.hexValue(), UIColor.flatBlue.hexValue(), UIColor.flatGreen.hexValue(),
                            UIColor.flatGray.hexValue(), UIColor.flatLime.hexValue(), UIColor.flatMint.hexValue(),
                            UIColor.flatPink.hexValue(), UIColor.flatSand.hexValue(),
                            UIColor.flatCoffee.hexValue(),
                            UIColor.flatWhite.hexValue(), UIColor.flatOrange.hexValue(),
                            UIColor.flatPurple.hexValue(), UIColor.flatYellow.hexValue(), UIColor.flatMagenta.hexValue()]
        
        //randomly selecting an element in array
        return randomColorVector.randomElement()!
    }
    
}
