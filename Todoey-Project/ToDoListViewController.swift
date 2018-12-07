//
//  ViewController.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/12/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit
import RealmSwift
//NSAttributedString.Key
//when creating a class that inherits from UITVC, there is no need to implement the TV protocols, delegate or datasource, delegate is seen already as this own class
class ToDoListViewController: SwipeTableViewController {

    //MARK: - Declaring global variables
    
    //initializing realm
    let realm = try! Realm()
    
    //selectCategory will be created once the user selects a list in the root table view
    var selectCategory: Category?{
        //didSet is activated once the optional variable selectCategory is finally created
        didSet{
           loadItems()
        }
    }

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //creating an array of objects of type Results, each obj in array is one item in list
    var todoItems: Results<Item>?
    
    //MARK: - Loading view fcts
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //defining the color that will be used for all the items
        let categoryColor = UIColor(hexString: selectCategory?.categoryColorHex ?? UIColor.randomFlat.hexValue())
        
        //defining black or white color that will be used to contrast with background
        let contrastColor = UIColor(contrastingBlackOrWhiteColorOn: categoryColor ?? UIColor.white, isFlat: true)
        
        //changing navigation bar tint color
        navigationController?.navigationBar.barTintColor = categoryColor
        
        //changing color of todoey icon
        navigationController?.navigationBar.tintColor = contrastColor
        
        //change list title color and the + sign color
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : contrastColor]
        
        //changing searchbar tint color
        searchBar.barTintColor = categoryColor
        
        //change searchBar border's color and border width
        searchBar.layer.borderColor = categoryColor?.cgColor
        searchBar.layer.borderWidth = 3
        
        //changing the search bar's textfield properties: background color and text color
        let searchTextField = searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.backgroundColor = categoryColor?.darken(byPercentage: 0.2)
        searchTextField.textColor = contrastColor
        
        //changing placeholder color (text in seachbar before user types anything
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: contrastColor])
        
        //changing title that appears at the top, after list is loaded
        title = selectCategory?.listName ?? "Todoey"
        
    }
    
    
    //MARK: - Configuring tableview
    
    //to set # of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //set properties of cells that are currently being displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //first call: when tableview gets loaded. Ad taht point, no item is loaded yet, even viewDidLoad. other calls: whenever tableView.reloadData() happens

        //creating cells based on super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        //adding message to blank lists
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.itemName
            
            //adding check/unchecked data
            cell.accessoryType = item.checked ? .checkmark : .none
            
            //assigning color information to cell
            //cell.backgroundColor = UIColor(hexString: item.itemColorHex)
            
            //assigning color information to cells based on list color, and making it darker depending on row index
            let cellColor = UIColor(hexString: selectCategory?.categoryColorHex ?? UIColor.randomFlat.hexValue())?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
            cell.backgroundColor = cellColor!
            
            //defining if text should be black or white to contrast with background
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cellColor!, isFlat: true)
            
        }

        return cell
    }
    
    
    //Allowing table view cells to be tapped and react
    
    //triggered when user taps at a row in table view. communicates with the delegate. Since we're using a TVC, this own class is the delegate already
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let checkedItem = todoItems?[indexPath.row].checked {
            do {
                try realm.write {
                    //inverting the status from checked to unchecked and vice-versa
                    todoItems![indexPath.row].checked = !checkedItem
                }
            } catch {
                print("Error in didAddNewItem when trying to write data in realm \(error)")
            }
        }
        
        //setting the animation to de-select an item (make the gray highlight disappear
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
        
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
            
            //userInput is set to receive its value in alert.addTextField, but can't pass values there, bc it will pass the value it has before receiving the user input. so instead, its value will be passed to todoItems here
            
            //checking if name of list (selectCategory) exists
            if self.selectCategory != nil {
                //creating new item to be appended
                let newItem = Item()
                newItem.itemName = userInput.text ?? ""
                //newItem.itemColorHex = UIColor.randomFlat.hexValue()
                
                do {
                    try self.realm.write {
                        //appending new item to list
                        self.selectCategory!.items.append(newItem)
                    }
                } catch {
                    print("Error in didAddNewItem when trying to write data in realm \(error)")
                }
                
//            //printing info of date and time after 1970 (in seconds)
//            print(newItem.currentDateTime)
            }

            self.tableView.reloadData()
            //self.saveItems()
            
            
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
    
    //MARK: - Save, load and delete items
    
    func loadItems(){

        //loading items in todoItems using realm
        todoItems = selectCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
            //selectCategory is a Category() object, contains listName string
            //in Category(): let items = List<Item>()
            //itemName is the string in Item.swift
        
        //sorting item by time created instead of alphabetical order 
        //todoItems = selectCategory?.items.sorted(byKeyPath: "currentDateTime", ascending: true)
        tableView.reloadData()
    }

    //deleting items
    override func updateModel(at indexPath: IndexPath) {
        
        if (todoItems?[indexPath.row]) != nil{
            do {
                try self.realm.write {
                    self.realm.delete(self.todoItems![indexPath.row])
                }} catch {
                    print("error at editActionsForRowAt: \(error)")
            }
        }
    }
}

//MARK: - Extending class to include Search Bar methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("itemName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "itemName", ascending: true)
            //itemName is the parameter that will be used for sorting

        //tableView.reloadData()

    }


    //this is called whenever there is a change in text in searchbar. allows clear icon to resume the regular list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //condition: search bar text count goes down to 0
        if searchBar.text?.count == 0 {
            loadItems()
                //loadItems already sets to sort items based on title

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
