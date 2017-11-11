//
//  GroupCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 10/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class GroupCell: UITableViewCell {

    
    @IBOutlet weak var imageViewHandler: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var tableWidth : CGFloat!
    var group : Group? {
        didSet {
            guard let group = group else { return  }
            
            titleLabel.text = group.title
            descriptionLabel.text = group.shortDescription
            let titleWidthWithConstraint = tableWidth - (titleTrailingConstraint.constant + titleLeadingConstraint.constant)
            let titleHeight = titleLabel.text?.height(constraintedWidth: titleWidthWithConstraint,
                                                      font: titleLabel.font)
            titleHeightConstraint.constant = titleHeight!
            titleLabel.setNeedsUpdateConstraints()

            if !group.url.isEmpty {
                let url = URL(string: group.url)
                self.imageViewHandler.sd_setImage(with: url) { (image, error, type, url) in
                    if error != nil {
                        log.error("\(error!)")
                    }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewHandler.image = nil
        imageViewHandler.sd_cancelCurrentImageLoad()
    }
    
    
}
