//
//  AppDelegate.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/12/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // first thing called when app is loaded
        
        //this only exists to catch if there is any error when initializing realm
        do {
            _ = try Realm()
        }
        catch{
            print("An error happened when initializing new realm at didFinishLaunchingWithOptions: \(error)")
        }
        
        //print relam file location
        print("realm directory is: \n")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print("\n ++++++++++++++++++++++++++++++++")
        return true
    }

    

}

