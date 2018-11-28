//
//  ViewController.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/12/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit
import CoreData

//when creating a class that inherits from UITVC, there is no need to implement the TV protocols, delegate or datasource, delegate is seen already as this own class
class ToDoListViewController: UITableViewController {

    //MARK: - Declaring global variables
    
    //selectCategory will be created once the user selects a list in the root table view
    var selectCategory: NewList?{
        //didSet is activated once the optional variable selectCategory is finally created
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //creting an array of objects of type ListDataModel
    var itemArray = [ListDataModel]()
    
    //creating obj to acces AppDelegate to use its persistentContainer variable
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
    }
    
    //MARK: - Configuring tableview
    
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
    
    
    //Allowing table view cells to be tapped and react
    
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
            
            //creating new obj using the entity ListDataModel
            let newItem = ListDataModel(context: self.context)
            
            //adding data to newItem, which is stored in "context" object
            newItem.itemContent = userInput.text
            newItem.checked = false
            //defining the parent category
            newItem.parentCategory = self.selectCategory
    
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
    
    //MARK: - Save and load items
    
    //send data to permanent storage inside persistentContainer
    func saveItems(){
        
        do {
            //saving to context
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        //reloading tableview data to display new entries in list. forces tableView(cellForRowAt) to be called
        self.tableView.reloadData()

    }
    
    func loadItems(with request: NSFetchRequest<ListDataModel> = ListDataModel.fetchRequest(), with predicate: NSPredicate? = nil){
        //adding predicate as one of the optional parameters to call the function

        //categoryPredicate is the predicate to be used when loading a list
        let categoryPredicate = NSPredicate(format: "parentCategory.listName MATCHES %@", selectCategory!.listName!)
            //parentCategory name must match what is stored in selectCategory.listName
        

        //optional binding to check whether loadItems was called with a predicate or not
        if let additionalPredicate = predicate {
            //if loadItems was called with an additional predicate (happens in searchbar), then the total predicate will be the sum of the regular predicate that loads list items + predicate to search for something
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            //requesting ListDataModel inside context data
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Extending class to include Search Bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //defining request to be used in loadItems
        let request: NSFetchRequest<ListDataModel> = ListDataModel.fetchRequest()
        
        //defining that the data should be fetched using the user input in searchBar
        let predicate = NSPredicate(format: "itemContent CONTAINS[cd] %@", searchBar.text!)
            //itemContent: parameter from ListDataModel we want to look at
            //CONTAINS %@: objective-c standard. Means it will look for whatever is set as argument, which in this case is "searchBNar.text!" realm cheat offers more info on useful operatos besides CONTAINS and %@
            //[cd]: tells search to ignore case and diacritics (especial accents)
        
        //sort the results based on the itemContent and use alphabetical order
        let sortDescriptor = NSSortDescriptor(key: "itemContent", ascending: true)
            //ascending: set alphabetical order
            //key: parameter used to sort results
        
        request.sortDescriptors = [sortDescriptor]
            //this parameter expeccts an array of things to sort for, but we are giving only one item

        loadItems(with: request, with: predicate)
        
        tableView.reloadData()
        
    }

    
    //this is called whenever there is a change in text in searchbar. allows clear icon to resume the regular list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            
            //placing the cancellation of the search option in the foreground
            DispatchQueue.main.async {
                //DispatchQueue assigns projects to different threads
                //actions here will happen in the main thread
                
                //cancelling search operation and hiding keyboard agian
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    

}
