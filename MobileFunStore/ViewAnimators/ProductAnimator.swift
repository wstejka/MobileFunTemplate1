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
        let fromVC  = transitionContext.viewController(forKey: .from) as! GroupDetailsViewController
        let toVC  = transitionContext.viewController(forKey: .to) as! ProductViewController
        
        
        let backgroundView = UIView(frame: fromVC.view.frame)
        container.addSubview(backgroundView)
        backgroundView.alpha = 0.2
        
        guard let productCell = fromVC.lastSelectedCell else { return }
        // Calculate the selected cell position in superview
        let rectOfCellInSuperview = fromVC.collectionView.convert(productCell.frame, to: fromVC.collectionView.superview)

        let imageView = UIImageView(frame: rectOfCellInSuperview)
        imageView.image = productCell.imageView.image
        imageView.contentMode = .scaleAspectFit
        backgroundView.addSubview(imageView)
        
        let inset : CGFloat = 10.0
        let imageWidth : CGFloat = toVC.productCellWidth - (2 * inset)
        let imageHeight : CGFloat = (toVC.productCellHeight / toVC.productCellWidth) * imageWidth
        let imagePositionY : CGFloat = (toVC.navigationController?.navigationBar.frame.origin.y)! +
            ((toVC.navigationController?.navigationBar.frame.height)!)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            imageView.frame.size = CGSize(width: imageWidth, height: imageHeight)
            imageView.frame.origin = CGPoint(x: inset, y: imagePositionY)
            backgroundView.alpha = 1.0
        }) { (_) in
            
            backgroundView.removeFromSuperview()
            container.addSubview(toVC.view)
            transitionContext.completeTransition(true)
        }
    }
    
    
    
}
