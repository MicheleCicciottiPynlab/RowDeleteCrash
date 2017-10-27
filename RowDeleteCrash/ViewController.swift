//
//  ViewController.swift
//  RowDeleteCrash
//
//  Created by a on 27/10/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet var actionButton: UIBarItem?
    
    lazy var controller: NSFetchedResultsController<Entity> = {
        do {
            let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
            fetchRequest.sortDescriptors = [.init(key: "index", ascending: true)]
            
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                        managedObjectContext: AppDelegate.instance.persistentContainer.viewContext,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: nil)
            
            controller.delegate = self
            try controller.performFetch()
            return controller
        }
        catch {
            fatalError("Unresolved error \(error)")
        }
    }()
    
    let maxEntityCount = 20
    
    @IBAction func prune() {
        let entities = controller.sections?.first?.objects as! [Entity]
        
        if entities.count <= maxEntityCount || entities.count < 1 {
            return
        }
        
        for index in maxEntityCount...entities.count - 1 {
            AppDelegate.instance.persistentContainer.viewContext.delete(entities[index])
        }
        
        AppDelegate.instance.saveContext()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return controller.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = controller.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntityRow", for: indexPath)
        cell.textLabel?.text = object.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AppDelegate.instance.persistentContainer.viewContext.delete(controller.object(at: indexPath))
            AppDelegate.instance.saveContext()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        if type == .delete {
            tableView.deleteRows(at: [indexPath!], with: .fade)
        } else {
            tableView.reloadData()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        actionButton?.isEnabled = (controller.sections?.first?.objects?.count ?? Int.min) > maxEntityCount
    }
}
