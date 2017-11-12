//
//  GroupAnimator.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 04/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class GroupAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
    
    private func moveFromGroup(groupVC: GroupViewController, toGroupDetails groupDetailsVC: GroupDetailsViewController, withContext context: UIViewControllerContextTransitioning)
    {
        if let indexPath = groupVC.tableView.indexPathForSelectedRow,
            // Get the original selected tableViewCell
            let selectedCell = groupVC.tableView.cellForRow(at: indexPath) as? GroupCell {
            //            var collectionCell = groupDetailsVC.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? GroupDetailsCollectionViewCell
            
            // Create temporary view for transparency effect
            let temporaryView = UIView(frame: context.containerView.frame)
            context.containerView.addSubview(temporaryView)
            
            // Calculate the selected cell position in table view
            let rectOfCell = groupVC.tableView.rectForRow(at: indexPath)
            let rectOfCellInSuperview = groupVC.tableView.convert(rectOfCell, to: groupVC.tableView.superview)
            
            // Create new UIView with the same frame as original TableViewCell
            let groupViewCell = UIView(frame: rectOfCellInSuperview)
            temporaryView.addSubview(groupViewCell)
            //            groupViewCell.backgroundColor = .orange
            
            // Create image view and add it at the same position in UIView as in original TableViewCell
            let imageView = UIImageView(frame: selectedCell.imageViewHandler.frame)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = selectedCell.imageViewHandler.image
            groupViewCell.addSubview(imageView)
            
            temporaryView.backgroundColor = .clear
            UIView.animate(withDuration: 0.3, animations: {
                temporaryView.backgroundColor = .white
                
            }, completion: { (status) in
                
                // >>> Now rebuild the context content
                // Add to context view groupDetails
                context.containerView.addSubview(groupDetailsVC.view)
                groupDetailsVC.view.addSubview(groupViewCell)
                
                // remove temporary view from context container
                temporaryView.removeFromSuperview()
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                    
                    groupViewCell.frame.origin.y = (groupDetailsVC.navigationController?.navigationBar.frame.origin.y)! +
                        ((groupDetailsVC.navigationController?.navigationBar.frame.height)!)
                    
                }, completion: { (status) in
                    
                    let titleLabel = UILabel(frame: selectedCell.titleLabel.frame)
                    titleLabel.text = selectedCell.titleLabel.text
                    titleLabel.font = selectedCell.titleLabel.font
                    titleLabel.numberOfLines = selectedCell.titleLabel.numberOfLines
                    groupViewCell.addSubview(titleLabel)
                    titleLabel.frame.origin.y = titleLabel.frame.origin.y + 100
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
            })
        }
    }
}

