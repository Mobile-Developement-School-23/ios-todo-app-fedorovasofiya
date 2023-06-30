//
//  Animator.swift
//  ToDoApp
//
//  Created by Sonya Fedorova on 01.07.2023.
//

import UIKit

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.8
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let initialFrame = originFrame
        let finalFrame = toView.frame
        
        let xScaleFactor = initialFrame.width / finalFrame.width
        let yScaleFactor = initialFrame.height / finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        toView.transform = scaleTransform
        toView.center = CGPoint(
            x: initialFrame.midX,
            y: initialFrame.midY
        )
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                toView.transform = .identity
                toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
    
}
