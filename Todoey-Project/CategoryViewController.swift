//
//  CategoryViewController.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/16/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLists()
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
    
    //cells currently being displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //first call: before viewDidLoad. Other calls when reloadData() is used
        
        //creating cell. withIdentifier must match the tableView name, seen in Table View Cell -> Identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummarizingLists", for: indexPath)
        
        //displaying the string stored in "listName" parameter as the cell content
        cell.textLabel?.text = listArray?[indexPath.row].listName ?? "No category added"
        
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
            
            //step 2: remove initialization of self.context when creating newList
            let newList = Category()
            
            if let inputFromUser = userInput.text {
                newList.listName = inputFromUser
            }
    
            //appending to list array is no longer a necessary command bc Result data type is auto-updating
            
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
    
    //MARK: - Saving and loading items
    func saveLists(with newList: Category){
        //step 3: save data to realm now, allow saveLists to have an input
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
    
    
    //MARK: - Tableview Delegate methods - what happens when we click in one of the cells
    
    //what happens when user selects an item in root list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    //preparing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //setting an object of ToDoListVC type
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = listArray?[indexPath.row]
        }
    }
    
}
