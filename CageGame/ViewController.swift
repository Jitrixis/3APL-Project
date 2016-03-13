//
//  ViewController.swift
//  CageGame
//
//  Created by Julien Gardet on 08/03/2016.
//  Copyright © 2016 Julien Gardet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //imgv.image = UIImage(named: "where-s-cage2.jpg")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: "You tapped at \(gestureRecognizer.locationInView(self.imgv))", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { _ in }))
        self.presentViewController(alertController, animated: true, completion: nil)
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

}

