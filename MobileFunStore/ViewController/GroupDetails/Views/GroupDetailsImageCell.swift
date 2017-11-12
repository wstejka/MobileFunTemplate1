//
//  GroupDetailsImageCell.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 25/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class GroupDetailsImageCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    private var imageViewModel : GDImagesViewModel!
    // MARK: - Const/Vars
    var item : GroupDetailsViewModel! {
        didSet {
            guard let imageVM = item as? GDImagesViewModel else {
                log.error("Cannot cast down to GDImagesViewModel")
                return
            }
            imageViewModel = imageVM
            guard let url = URL(string: imageViewModel.group.url) else { return }
            imageView.sd_setImage(with: url, completed: nil)
            imageView.contentMode = .scaleAspectFit
            
            self.contentView.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint.constant = imageViewModel.collectionWidth
            heightConstraint.constant = imageViewModel.collectionWidth * imageViewModel.heightToWidthFactor

        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        log.verbose("")
        
    }
    
}


