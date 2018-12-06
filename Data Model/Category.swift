//
//  Category.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/28/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var listName = ""
    
    //stores category color info in hexadecimal 
    @objc dynamic var categoryColorHex = ""
    
    //forward relationship between data types
    let items = List<Item>()
        //List is a type from RealSwift, very similar to an array
}
