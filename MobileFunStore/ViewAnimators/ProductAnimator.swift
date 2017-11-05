//
//  ProductAnimator.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 04/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class ProductAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        let fromVC  = transitionContext.viewController(forKey: .from)
        let toVC  = transitionContext.viewController(forKey: .to)

//        container.addSubview((toVC?.view)!)
        
        let imageView = UIView(frame: CGRect(x: 0.0,
                                             y: (fromVC?.view.center.y)!, width: 100.0, height: 100.0))
        imageView.backgroundColor = .orange
        container.addSubview(imageView)
        
        UIView.animate(withDuration: 0.1, animations: {
            
            imageView.frame.size = CGSize(width: 200.0, height: 400.0)
        }) { (_) in
            
            imageView.removeFromSuperview()
            container.addSubview((toVC?.view)!)
            transitionContext.completeTransition(true)
        }
    }
    
    
    
}
