//
//  ListDataModel.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/13/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import Foundation

//this class was developed to handle the entries in the list
class ListDataModel {
    
    var itemContent = ""
    var checked = false
    
    init(_itemContent: String, _checked: Bool) {
        itemContent = _itemContent
        checked = _checked
    }
    
}
