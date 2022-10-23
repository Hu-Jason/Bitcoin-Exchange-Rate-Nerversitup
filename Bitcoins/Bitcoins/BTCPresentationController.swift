//
//  BTCPresentationController.swift
//  Bitcoins
//
//  Created by SukPoet on 2022/10/22.
//

import UIKit

class BTCPresentationController: UIPresentationController {
    let dimmingView = UIView()
    
    // MARK: - Initializers
    override init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    func setupDimmingView() {
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        dimmingView.frame = containerView?.bounds ?? CGRect()
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmingView, at: 0)
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { [weak wDim = dimmingView] _ in
            wDim?.alpha = 1.0;
        })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        coordinator.animate { [weak wDim = dimmingView] _ in
            wDim?.alpha = 0.0
        } completion: { [weak wDim = dimmingView] context in
            if !context.isCancelled {
                wDim?.removeFromSuperview()
            }
        }

    }
}
