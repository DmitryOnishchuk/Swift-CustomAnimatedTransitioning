//
//  MiniToLargeTransitionCoordinator.swift
//  TestCV
//
//  Created by Dmitry Onishchuk on 28.09.2021.
//

import Foundation
import UIKit

class MiniToLargeTransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: Properties
    
    var toViewController: DetailVC?
    lazy var toViewControllerInitialYPosition: CGFloat = {
//        let bottomTriggerViewHeight: CGFloat = fromViewControllerGestureView?.frame.minY ?? 0
//        print(bottomTriggerViewHeight)
//        let viewYPosition = self.toViewController?.view.frame.minY ?? 0
//        print(viewYPosition)
//        let y = bottomTriggerViewHeight + viewYPosition
        let point = fromViewControllerGestureView!.convert(fromViewController.view.frame.origin, to: fromViewController.view)
        print(point.y)
       // return fromViewControllerGestureView?.frame.minY ?? 0
        return point.y
    }()
    //lazy var bottomTriggerImageViewHeight: CGFloat = toViewController?.cardImageViewHeight ?? 0
    var interactivePresentTransition: MiniToLargeViewInteractiveAnimator?
    var interactiveDismissTransition: MiniToLargeViewInteractiveAnimator?
    var fromViewControllerGestureView: UIView?
    var fromViewController: UIViewController!
    
    // MARK: Methods
    
    func prepareViewForCustomTransition(fromViewController: MainVC, bottomTriggerView: UIView, textForDetailVC: String) {
        if self.toViewController != nil { return }
        let toViewController = DetailModuleBuilder().create(place: textForDetailVC)
        self.fromViewController = fromViewController
        toViewController.transitioningDelegate = self
        toViewController.modalPresentationStyle = .custom
        interactivePresentTransition = MiniToLargeViewInteractiveAnimator(fromViewController: fromViewController,
                                                                          toViewController: toViewController,
                                                                          gestureView: bottomTriggerView)
        interactiveDismissTransition = MiniToLargeViewInteractiveAnimator(fromViewController: toViewController,
                                                                          toViewController: nil,
                                                                          gestureView: toViewController.view)
        self.toViewController = toViewController
        self.fromViewControllerGestureView = bottomTriggerView
    }
    
    func removeCustomTransitionBehaviour() {
        interactivePresentTransition = nil
        interactiveDismissTransition = nil
        toViewController = nil
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MiniToLargePresentingViewAnimator(initialY: toViewControllerInitialYPosition,
                                                 fromViewWidth: fromViewControllerGestureView!.bounds.width)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MiniToLargeDismissingViewAnimator(initialY: toViewControllerInitialYPosition)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let presentInteractor = interactivePresentTransition else {
            return nil
        }
        guard presentInteractor.isTransitionInProgress else {
            return nil
        }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let dismissInteractor = interactiveDismissTransition else {
            return nil
        }
        guard dismissInteractor.isTransitionInProgress else {
            return nil
        }
        return dismissInteractor
    }
}
