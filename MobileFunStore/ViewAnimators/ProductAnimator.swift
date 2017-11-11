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
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC  = transitionContext.viewController(forKey: .from) as? GroupDetailsViewController,
            let toVC  = transitionContext.viewController(forKey: .to) as? ProductViewController else {
                return
        }
        
        let container = transitionContext.containerView
        let backgroundView = UIView(frame: fromVC.view.frame)
        backgroundView.backgroundColor = .white
        container.addSubview(backgroundView)
        backgroundView.alpha = 0.2
        
        guard let productCell = fromVC.lastSelectedCell else { return }
        // Calculate the selected cell position in superview
        let rectOfCellInSuperview = fromVC.collectionView.convert(productCell.frame, to: fromVC.collectionView.superview)

        
        let imageView = UIImageView(frame: CGRect(origin: rectOfCellInSuperview.origin, size: productCell.imageView.frame.size))
        imageView.image = productCell.imageView.image
        imageView.contentMode = .scaleAspectFit
        backgroundView.addSubview(imageView)
        
        let imageWidth : CGFloat = (toVC.tableView.superview?.frame.width)!
        let imagePositionY : CGFloat = (toVC.navigationController?.navigationBar.frame.origin.y)! +
            ((toVC.navigationController?.navigationBar.frame.height)!)
        let imageHeight : CGFloat = (toVC.tableView.superview?.frame.height)! - imagePositionY

        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            
            let imageViewModel = toVC.items[toVC.indexOfItem(type: ProductItemType.image)!] as! ImagesViewModel
            imageView.frame.size = CGSize(width: imageWidth, height: imageHeight * imageViewModel.heightFactor)
            imageView.frame.origin = CGPoint(x: 0.0, y: imagePositionY)
            backgroundView.alpha = 1.0
        }) { (_) in
            
            backgroundView.removeFromSuperview()
            container.addSubview(toVC.view)
            transitionContext.completeTransition(true)
        }
    }
    
    
    
}
