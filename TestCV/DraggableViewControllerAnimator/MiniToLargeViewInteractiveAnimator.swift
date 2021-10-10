//
//  MiniToLargeViewInteractiveAnimator.swift
//  TestCV
//
//  Created by Dmitry Onishchuk on 28.09.2021.
//

import Foundation
import UIKit

class MiniToLargeViewInteractiveAnimator: UIPercentDrivenInteractiveTransition,UIGestureRecognizerDelegate {
    let fromViewController: UIViewController
    let toViewController: UIViewController?
    var isTransitionInProgress = false
    var isEnabled = true {
        didSet {
            pan.isEnabled = isEnabled
        }
    }
    private var shouldComplete = false
    private let threshold: CGFloat = 0.3
    private let targetScreenHeight = UIScreen.main.bounds.height - 150
    private lazy var dragAmount = toViewController == nil ? targetScreenHeight : -targetScreenHeight
    private lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        pan.cancelsTouchesInView = false
        pan.addTarget(self, action: #selector(onPan(_:)))
        return pan
    }()
    
    init(fromViewController: UIViewController, toViewController: UIViewController?, gestureView: UIView) {
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        super.init()
        gestureView.addGestureRecognizer(self.pan)
        completionSpeed = 0.6
    }
    
    deinit {
        pan.view?.removeGestureRecognizer(pan)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        let velocity = panRecognizer.velocity(in: fromViewController.view)
        if abs(velocity.x) > abs(velocity.y) {
            return false
        }
        return true
    }
    
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        switch pan.state {
        case .began:
            isTransitionInProgress = true
            if let toViewController = toViewController {
                fromViewController.present(toViewController, animated: true, completion: nil)
            } else {
                fromViewController.dismiss(animated: true, completion: nil)
            }
        case .changed:
            isTransitionInProgress = true
            var percent = translation.y / dragAmount
            percent = fmax(percent, 0)
            percent = fmin(percent, 1)
            update(percent)
            shouldComplete = percent > threshold
            if shouldComplete {
                (fromViewController as? MiniToLargeAnimatable)?.prepareBeingDismissed()
                finish()
            }
        case .ended:
            shouldComplete ? finish() : cancel()
            isTransitionInProgress = false
        case .cancelled:
            cancel()
            isTransitionInProgress = false
        default:
            isTransitionInProgress = false
        }
    }
}
