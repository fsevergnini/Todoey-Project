//
//  Item.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/28/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var itemName = ""
    @objc dynamic var checked = false
    
    //to obtain the amount of seconds when data was created
    @objc dynamic var currentDateTime = Date().timeIntervalSince1970
    
    //stores color of an item in hexadecimal
    //@objc dynamic var itemColorHex = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
        //LinkingObjects is a realm resource to indicate parent category
        //property is the name of the forward relationship
}
