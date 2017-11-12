//
//  GroupDetailsLabelCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 29/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

protocol GroupDetailsLabelCellDelegate {
    
//    func resizeCell(<#parameters#>) -> <#return type#> {
//    <#function body#>
//    }
}

class GroupDetailsLabelCell : UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
    // MARK: - Const/Vars
    
    var item : LabelModel! {
        didSet {
            self.textLabel.text = item.text
            self.textLabel.font = item.font
            self.textLabel.numberOfLines = item.getLines

            self.contentView.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint.constant = item.labelWidth
        }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }

    // MARK: - methods
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        log.verbose("")
        
        if sender.state == .ended {
//            if shortTextVersion {
//                textLabel.numberOfLines = 0
//                textLabel.lineBreakMode = .byWordWrapping
//            } else {
//                textLabel.numberOfLines = 2
//                textLabel.lineBreakMode = .byTruncatingTail
//            }
//            shortTextVersion = !shortTextVersion
//            self.tag = shortTextVersion == true ? 1 : 0
//            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
}
