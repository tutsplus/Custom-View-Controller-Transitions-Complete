//
//  CustomTransition.swift
//  Custom Transitions
//
//  Created by Davis Allie on 17/01/2016.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import Foundation
import UIKit

enum TransitionType {
    case Presenting, Dismissing
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: NSTimeInterval
    var isPresenting: Bool
    var originFrame: CGRect
    
    init(withDuration duration: NSTimeInterval, forTransitionType type: TransitionType, originFrame: CGRect) {
        self.duration = duration
        self.isPresenting = type == .Presenting
        self.originFrame = originFrame
        
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        
        let detailView = self.isPresenting ? toView : fromView
        
        if self.isPresenting {
            containerView.addSubview(toView)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        detailView.frame.origin = self.isPresenting ? self.originFrame.origin : CGPoint(x: 0, y: 0)
        detailView.frame.size.width = self.isPresenting ? self.originFrame.size.width : containerView.bounds.width
        detailView.layoutIfNeeded()
        
        for view in detailView.subviews {
            if !(view is UIImageView) {
                view.alpha = isPresenting ? 0.0 : 1.0
            }
        }
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            detailView.frame = self.isPresenting ? containerView.bounds : self.originFrame
            detailView.layoutIfNeeded()
            
            for view in detailView.subviews {
                if !(view is UIImageView) {
                    view.alpha = self.isPresenting ? 1.0 : 0.0
                }
            }
        }) { (completed: Bool) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.transitioningDelegate = self
        (segue.destinationViewController as? DetailViewController)?.rootViewController = self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(withDuration: 3.0, forTransitionType: .Dismissing, originFrame: self.image.frame)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(withDuration: 3.0, forTransitionType: .Presenting, originFrame: self.image.frame)
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
