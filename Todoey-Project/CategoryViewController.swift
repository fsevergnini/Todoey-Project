//
//  CategoryViewController.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/16/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLists()
    }
    
    //MARK: - Global variables for CategoryViewController
    
    //creating array of objects of type NewList
    var listArray = [NewList]()
    
    //creating obj to acceess APpDelegate and use its persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Configuring the tableview
    
    //number of rows in tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    //cells currently being displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //first call: before viewDidLoad. Other calls when reloadData() is used
        
        //creating cell. withIdentifier must match the tableView name, seen in Table View Cell -> Identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummarizingLists", for: indexPath)
        
        //displaying the string stored in "listName" parameter as the cell content
        cell.textLabel?.text = listArray[indexPath.row].listName
        
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
            
            let newList = NewList(context: self.context)
            
            newList.listName = userInput.text
            
            self.listArray.append(newList)
            
            self.saveLists()
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
    func saveLists(){
        
        do {try context.save()}
        catch {print("error saving context: \(error)")}
        
        self.tableView.reloadData()
    }
    
    
    func loadLists(with request: NSFetchRequest<NewList> = NewList.fetchRequest()){
        
        do{listArray = try context.fetch(request)}
        catch{print("error loading items: \(error)")}
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
            destinationVC.selectCategory = listArray[indexPath.row]
        }
    }
    
}
