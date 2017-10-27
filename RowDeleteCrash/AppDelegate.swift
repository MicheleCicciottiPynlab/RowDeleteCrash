//
//  AppDelegate.swift
//  RowDeleteCrash
//
//  Created by a on 27/10/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var instance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }

    private static let entities = ["Piemonte",
                                   "Valle d´Aosta",
                                   "Lombardia",
                                   "Trentino-Alto Adige",
                                   "Veneto",
                                   "Friuli-Venezia Giulia",
                                   "Liguria",
                                   "Emilia-Romagna",
                                   "Toscana",
                                   "Umbria",
                                   "Marche",
                                   "Lazio",
                                   "Abruzzi",
                                   "Molise",
                                   "Campania",
                                   "Puglia",
                                   "Basilicata",
                                   "Calabria",
                                   "Sicilia",
                                   "Sardegna",
                                   "Eritrea",
                                   "Somalia",
                                   "Libia",
                                   "Etiopia"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        do {
            let deleteAll = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Entity"))
            try persistentContainer.viewContext.execute(deleteAll)
            
            var index = 0
            
            for entityName in AppDelegate.entities {
                let entity = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: persistentContainer.viewContext) as! Entity
                entity.title = entityName
                entity.index = Int32(index)
                index += 1
            }
            
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        } catch {}
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RowDeleteCrash")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
