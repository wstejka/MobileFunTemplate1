//
//  GroupTableViewCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 10/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class GroupTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewHandler: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var group : Group? {
        didSet {
            guard let group = group else { return  }
            
            titleLabel.text = group.title
            descriptionLabel.text = group.shortDescription
            let titleHeight = titleLabel.text?.height(constraintedWidth: titleLabel.frame.width,
                                                      font: titleLabel.font)
            titleHeightConstraint.constant = titleHeight!
            
            if !group.imageName.isEmpty {
                Storage.storage().reference().child(group.imageName).downloadURL { [unowned self] (url, error) in
                    
                    self.imageViewHandler.sd_setImage(with: url) { (image, error, type, url) in
                        if error != nil {
                            log.error("\(error!)")
                        }
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
