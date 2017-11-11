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
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var shortDecription: UILabel!
    
    // MARK: - Const/Vars
    private var isShortDescription : Bool = true
    var collectionView : UICollectionView?
    var group : Group? {
        
        didSet {
            guard let group = group else { return }
            title.text = group.title
            shortDecription.text = group.shortDescription
            guard let url = URL(string: group.url) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        log.verbose("")
        
    }
    
}
