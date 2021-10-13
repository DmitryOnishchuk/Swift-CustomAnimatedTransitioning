//
//  MiniToLargeDismissingViewAnimator.swift
//  TestCV
//
//  Created by Dmitry Onishchuk on 28.09.2021.
//

import Foundation
import UIKit

class MiniToLargeDismissingViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval
    let doneY: CGFloat
    let toViewWidth: CGFloat
    
    init(duration: TimeInterval = 0.4, doneY: CGFloat, toViewWidth:CGFloat) {
        self.duration = duration
        self.doneY = doneY
        self.toViewWidth = toViewWidth
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from),
              let animatableFromVC = fromVC as? MiniToLargeAnimatable else {
                  return
              }
        var fromVCRect = transitionContext.initialFrame(for: fromVC)
        
        fromVCRect.origin.y = doneY
        fromVCRect.origin.x = (fromVCRect.size.width - toViewWidth) / 2
        fromVCRect.size.width = toViewWidth
        animatableFromVC.animatableBackgroundView.alpha = 1
        animatableFromVC.animatableMainView.layer.cornerRadius = 40
        fromVC.view.frame = fromVCRect

        
        UIView.animate(withDuration: duration, animations: {
            animatableFromVC.animatableMainView.frame = fromVCRect
            animatableFromVC.animatableBackgroundView.alpha = 0
            animatableFromVC.animatableMainView.layer.cornerRadius = 10
        }) { (_) in
            if !transitionContext.transitionWasCancelled {
                fromVC.beginAppearanceTransition(false, animated: true)
                toVC.beginAppearanceTransition(true, animated: true)
                fromVC.endAppearanceTransition()
                toVC.endAppearanceTransition()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
