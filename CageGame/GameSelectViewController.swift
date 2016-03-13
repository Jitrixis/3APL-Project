//
//  GameSelectViewController.swift
//  CageGame
//
//  Created by Julien Gardet on 13/03/2016.
//  Copyright © 2016 Julien Gardet. All rights reserved.
//


import UIKit
import CoreData

class GameSelectViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        if self.fetchedResultsController.sections![0].numberOfObjects == 0 {
            //Default images
            _ = insertNewObject("Cage in an orchestra", uri: "where-s-cage1.jpg", cageX: 143, cageY: 346, cageW: 7, cageH: 11)
            _ = insertNewObject("Cage in the crowd", uri: "where-s-cage2.jpg", cageX: 198, cageY: 269, cageW: 5, cageH: 8)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Insert Entity
    
    func insertNewObject(name: String, uri: String, cageX: Int, cageY: Int, cageW: Int, cageH: Int) {
        let context = self.fetchedResultsController.managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: context)
        newManagedObject.setValue(name, forKey: "name")
        newManagedObject.setValue(uri, forKey: "uri")
        newManagedObject.setValue(cageX, forKey: "cageX")
        newManagedObject.setValue(cageY, forKey: "cageY")
        newManagedObject.setValue(cageW, forKey: "cageW")
        newManagedObject.setValue(cageH, forKey: "cageH")
        
        // Save the context.
        do {
            try context.save()
        } catch {
            abort()
        }
    }
    
    // MARK : Manager Rows
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
        cell.textLabel!.text = object.valueForKey("name")!.description
    }
    
    // MARK : CORE DATA Fetch Result
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        //Init fetch
        let fetchRequest = NSFetchRequest()
        
        //Select Entity
        let entity = NSEntityDescription.entityForName("Image", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        //Limit Fetch
        fetchRequest.fetchBatchSize = 20
        
        // Sort Fetch
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Request Fetch
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        //Apply Fetch
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            abort()
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    // MARK : Data change
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    // MARK: Send Data to Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playImage" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = segue.destinationViewController as! GamePlayViewController
                controller.detailItem = object
            }
        }
    }
    
}
