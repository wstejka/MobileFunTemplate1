//
//  NavigationDelegate.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 02/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class NavigationDelegate: NSObject , UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var animator : UIViewControllerAnimatedTransitioning? = nil
        if let _ = fromVC as? GroupViewController,
            let _ = toVC as? GroupDetailsViewController {
            animator = GroupAnimator()
        }
        else if let _ = fromVC as? GroupDetailsViewController,
            let _ = toVC as? ProductViewController {
            animator = ProductAnimator()
        }
        return animator
    }
    
}




