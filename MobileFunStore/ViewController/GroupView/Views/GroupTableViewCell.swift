//
//  GroupTableViewCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 10/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewHandler: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var group : Group? {
        didSet {
            guard let group = group else { return  }
            let imageURL = URL(string: group.url)
            imageViewHandler.sd_setImage(with: imageURL) { (image, error, type, url) in
                if error != nil {
                    log.error("\(error!)")
                }
            }
            titleLabel.text = group.title
            descriptionLabel.text = group.description
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewHandler.image = nil
        imageViewHandler.sd_cancelCurrentImageLoad()
    }
}
