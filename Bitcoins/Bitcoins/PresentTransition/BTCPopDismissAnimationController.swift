//
//  BTCPopDismissAnimationController.swift
//  Bitcoins
//
//  Created by SukPoet on 2022/10/22.
//

import UIKit

class BTCPopDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey:.from) else {
            transitionContext.completeTransition(true)
            return
        }
        let animationDuration = transitionDuration(using: transitionContext)
        let frame = containerView.bounds
        let frame2Animate = CGRect(x: frame.origin.x, y: frame.size.height, width: frame.size.width, height: frame.size.height)
        UIView.animate(withDuration: animationDuration, animations: {
            fromView.frame = frame2Animate
        }, completion: { finished in
            let complete = (finished && !transitionContext.transitionWasCancelled)
            if complete {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(complete)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
}
