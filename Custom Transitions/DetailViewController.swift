//
//  DetailViewController.swift
//  Custom Transitions
//
//  Created by Davis Allie on 16/01/2016.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var rootViewController: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanDown(sender: UIPanGestureRecognizer) {
        let progress = sender.translationInView(self.view).y/self.view.frame.size.height
        switch sender.state {
        case .Began:
            self.rootViewController.interactionController = UIPercentDrivenInteractiveTransition()
            self.dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            self.rootViewController.interactionController?.updateInteractiveTransition(progress)
        case .Ended:
            if progress >= 0.5 {
                self.rootViewController.interactionController?.finishInteractiveTransition()
            } else {
                self.rootViewController.interactionController?.cancelInteractiveTransition()
            }
            
            self.rootViewController.interactionController = nil
        default:
            self.rootViewController.interactionController?.cancelInteractiveTransition()
            self.rootViewController.interactionController = nil
        }
    }

    @IBAction func didPressToClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
