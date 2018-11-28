//
//  AppDelegate.swift
//  Todoey-Project
//
//  Created by Frederico Severgnini on 11/12/18.
//  Copyright © 2018 Frederico Severgnini. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // first thing called when app is loaded
        
        
        //creating a realm type object based on realm class "Data()"
        let data = Data()
        data.name = "Djaphyr"
        data.age = 576
        
        
        do {
            let realm = try Realm()
            
            //commiting to realm
            try realm.write {
                //defining which objects to be added
                realm.add(data)
            }
        }
        catch{
            print("An error happened when initializing new realm at didFinishLaunchingWithOptions: \(error)")
        }
        
        //print relam file location
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        //creates a new container named "DataModel" just as the DataModel.xcdatamodeld file we have. It's a SQlite database
        let container = NSPersistentContainer(name: "DataModel")
        //load the container
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            //checking for errors when loading
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        //this value will be set to the "let container" constant established
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    //saves data when app is terminated
    func saveContext () {
        //context allows data to be changed. it's a temporary storage
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                //saving data from context to permanent storage (=container)
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

