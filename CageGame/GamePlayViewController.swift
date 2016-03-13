//
//  GamePlayViewController.swift
//  CageGame
//
//  Created by Julien Gardet on 13/03/2016.
//  Copyright © 2016 Julien Gardet. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController {
    
    // MARK : Outlets
    
    @IBOutlet weak var gameTimer: UINavigationItem!
    @IBOutlet weak var gameImage: UIImageView!
    
    var timer = NSTimer()
    var counter = 0
    var lastClickAt = -2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        if cageX1 <= Int(click.x) && Int(click.x) <= cageX2 && cageY1 <= Int(click.y) && Int(click.y) <= cageY2{
            //WIN
            self.pauseTimer()
            
            let alertController = UIAlertController(title: nil, message: "You win in \(counter) seconds !", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { _ in }))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            //TODO Record
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
    
    // MARK
    
}