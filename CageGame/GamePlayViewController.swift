//
//  GamePlayViewController.swift
//  CageGame
//
//  Created by Julien Gardet on 13/03/2016.
//  Copyright © 2016 Julien Gardet. All rights reserved.
//

import UIKit
import CoreData

class GamePlayViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK : Outlets
    
    @IBOutlet weak var gameTimer: UINavigationItem!
    @IBOutlet weak var gameImage: UIImageView!
    
    var timer = NSTimer()
    var counter = 0
    var lastClickAt = -2
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        self.configureView()
        
        self.startTimer()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("bgObserver"), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("fgObserver"), name:UIApplicationWillEnterForegroundNotification, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK : Timer handler
    
    func updateCounter() {
        counter++
        gameTimer.title = String("Timer : \(counter) s.")
        if self.counter - self.lastClickAt <= 2 {
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        }else{
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        }
    }
    
    func fgObserver(){
        self.startTimer()
    }
    
    func bgObserver(){
        self.pauseTimer()
    }
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }
    
    func pauseTimer(){
        timer.invalidate()
    }
    
    // MARK : Retrieve passed data
    
    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let image = self.gameImage {
                image.image = UIImage(named: detail.valueForKey("uri")!.description)
            }
        }
    }
    
    // MARK : Handle Action
    
    @IBAction
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let click = gestureRecognizer.locationInView(self.gameImage)
        
        let cageX1 = self.detailItem?.valueForKey("cageX") as! Int
        let cageY1 = self.detailItem?.valueForKey("cageY") as! Int
        let cageX2 = self.detailItem?.valueForKey("cageX") as! Int + (self.detailItem?.valueForKey("cageW") as! Int)
        let cageY2 = self.detailItem?.valueForKey("cageY") as! Int + (self.detailItem?.valueForKey("cageH") as! Int)
        
        // 2 sec tap
        if self.counter - self.lastClickAt <= 2 {
            return
        }
        
        //WIN
        if cageX1 <= Int(click.x) && Int(click.x) <= cageX2 && cageY1 <= Int(click.y) && Int(click.y) <= cageY2{
            //Stop Timer
            self.pauseTimer()
            
            //Display
            let alertController = UIAlertController(title: nil, message: "You win in \(counter) seconds !", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                //Save Score
                let textField = alertController.textFields![0] as UITextField
                print(textField.text)
                //self.insertNewObject(textField.text!, score: self.counter)
                
                //Go Back Game
                let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GameSelect") as! GameSelectViewController
                self.navigationController?.showViewController(secondViewController, sender: nil)
            }))
            alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "Username"
            })
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
            self.lastClickAt = self.counter
        }
    }
    
    @IBAction
    func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    @IBAction
    func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformScale(view.transform,
                recognizer.scale, recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    // MARK : Save score
    
    
    // MARK : Insert Entity
    
    func insertNewObject(player: String, score: Int) {
        let context = self.managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Score", inManagedObjectContext: context)
        newManagedObject.setValue(player, forKey: "player")
        newManagedObject.setValue(score, forKey: "score")
        
        newManagedObject.mutableSetValueForKey("image").addObject(self.detailItem!)
        
        // Save the context.
        do {
            try context.save()
        } catch {
            abort()
        }
    }
    
}