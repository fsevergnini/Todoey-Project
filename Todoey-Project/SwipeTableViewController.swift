//
//  SwipeTableViewController.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 12/3/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
 
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    //MARK: - configuring swipe left to delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("deleting row number \(indexPath.row)")
                        
            self.updateModel(at: indexPath)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    //allows item to be deleted by swiping all the way to the left
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive //destructive is the name for this swiping all the way to delete
        return options
        
    }
    
    //update tableview to remove deleted items
    func updateModel(at indexPath: IndexPath){
        
    }
    
    //MARK: - Configuring tableView parameters 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating cell. withIdentifier must match the tableView name, seen in Table View Cell -> Identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        
        //delegate for swipeTableView
        cell.delegate = self
        
        return cell
    }

}

