//
//  NavigationDelegate.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 02/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class NavigationDelegate: NSObject , UINavigationControllerDelegate {

    private let animator = Animator()
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var animator : UIViewControllerAnimatedTransitioning? = nil
        if let _ = fromVC as? GroupViewController,
            let _ = toVC as? GroupDetailsViewController {
            animator = Animator()
        }
        return animator
    }
    
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let _ = context?.viewController(forKey: UITransitionContextViewControllerKey.from) as? GroupViewController,
            let _ = context?.viewController(forKey: UITransitionContextViewControllerKey.to) as? GroupDetailsViewController {
            return 0.8
        }
        return 0.4
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        
        // push
        if let groupVC = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? GroupViewController,
            let groupDetailsVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? GroupDetailsViewController {
            moveFromGroup(groupVC: groupVC, toGroupDetails: groupDetailsVC, withContext: context)
        }
        // pop
//        else if let groupVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? GroupViewController,
//            let groupDetailsVC = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? GroupDetailsViewController {
//            moveFromPosts(groupVC, toCategories: groupDetailsVC, withContext: context)
//
//        }
        
    }
    
    private var selectedCellFrame: CGRect? = nil
    private var originalTableViewY: CGFloat? = nil
    
    private func createTransitionImageViewWithFrame(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
//        imageView. setupDefaultTopInnerShadow()       <<===
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func moveFromGroup(groupVC: GroupViewController, toGroupDetails groupDetailsVC: GroupDetailsViewController, withContext context: UIViewControllerContextTransitioning)
    {
        if let indexPath = groupVC.tableView.indexPathForSelectedRow,
            // Get the original selected tableViewCell
            let selectedCell = groupVC.tableView.cellForRow(at: indexPath) as? GroupTableViewCell {
            
            // Add to context view groupDetails
            context.containerView.addSubview(groupDetailsVC.view)
            
            // Calculate the selected cell position in table view
            let rectOfCell = groupVC.tableView.rectForRow(at: indexPath)
            let rectOfCellInSuperview = groupVC.tableView.convert(rectOfCell, to: groupVC.tableView.superview)

            // Create new UIView with the same frame as original TableViewCell
            let groupViewCell = UIView(frame: rectOfCellInSuperview)
            groupDetailsVC.view.addSubview(groupViewCell)
            
            // Create image view and add it at the same position in UIView as in original TableViewCell
            let imageView = UIImageView(frame: selectedCell.imageViewHandler.frame)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = selectedCell.imageViewHandler.image
            groupViewCell.addSubview(imageView)

            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                groupViewCell.frame.origin.y = (groupDetailsVC.navigationController?.navigationBar.frame.origin.y)! +
                                                ((groupDetailsVC.navigationController?.navigationBar.frame.height)!) + 12

            }, completion: { (status) in

                let titleLabel = UILabel(frame: selectedCell.titleLabel.frame)
                titleLabel.text = selectedCell.titleLabel.text
                titleLabel.font = selectedCell.titleLabel.font
                groupViewCell.addSubview(titleLabel)
                titleLabel.frame.origin.y = titleLabel.frame.origin.y + 50
                titleLabel.alpha = 0.2

                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {

                    titleLabel.frame.origin.y = selectedCell.titleLabel.frame.origin.y
                    titleLabel.alpha = 1.0
                    
                }, completion: { (status) in
                    
                    groupDetailsVC.alphaView.alpha = 0.0
                    groupViewCell.removeFromSuperview()
                    context.completeTransition(status)

                })
            })
        }
    }
}



