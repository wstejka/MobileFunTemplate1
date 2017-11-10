//
//  ImageZoomAnimator.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 06/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class ImageZoomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var fromVC : UIViewController!
    
    init(fromViewController : UIViewController) {
        fromVC = fromViewController
        super.init()
    }
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {

        return 0.5
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        
        // push
        
        if let fromVC = fromVC as? ProductViewController,
            let toVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? ImageZoomingViewController {
            
            let content = context.containerView
            let backgroundView = UIView(frame: fromVC.view.frame)
            backgroundView.backgroundColor = .white
            content.addSubview(backgroundView)
            backgroundView.alpha = 0.5

            let section = fromVC.indexOfItem(type: .image)!
            guard let imageCell = fromVC.tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? ProductImageTableViewCell else { return }
//            let snapshot = imageCell.snapshotView(afterScreenUpdates: false)
            // Calculate the selected cell position in superview
            let rectOfCellInSuperview = fromVC.tableView.convert(imageCell.frame, to: fromVC.tableView.superview)

            let imageView = UIImageView(frame: rectOfCellInSuperview)
            imageView.image = toVC.images[toVC.currentIndex]
            imageView.contentMode = .scaleAspectFit
            backgroundView.addSubview(imageView)
            
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                backgroundView.alpha = 1.0
                imageView.frame = CGRect(origin: toVC.mainScrollView.frame.origin,
                                         size: toVC.scrollViewSize)
                
            }) { (_) in
                
                backgroundView.removeFromSuperview()
                context.containerView.addSubview(toVC.view)
                context.completeTransition(true)
            }

        }

        
    }
    

}

