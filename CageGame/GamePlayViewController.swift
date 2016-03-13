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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        print("me")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if cageX1 <= Int(click.x) && Int(click.x) <= cageX2 && cageY1 <= Int(click.y) && Int(click.y) <= cageY2{
            let alertController = UIAlertController(title: nil, message: "You win !", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { _ in }))
            self.presentViewController(alertController, animated: true, completion: nil)
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