
//  GroupDetailsViewController.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 25/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import FirebaseFirestore


struct GroupDetailsConstants {
    
    static let standardLeftInset : CGFloat = 8.0
    static let standardRightInset : CGFloat = 8.0
    static let standardTopInset : CGFloat = 10.0
}

extension GroupDetailsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        log.verbose("")

        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        log.verbose("numberOfItemsInSection")
        var itemInSection = 0
        if section == 0 {
            itemInSection = 2
        }
        else if section == 1 {
            itemInSection = productCollection.count
        }
//        else {
//            itemInSection = 1
//        }
        
        return itemInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var reusableCell : UICollectionViewCell!
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as! GroupDetailsTopCollectionViewCell
            cell.collectionView = collectionView
            cell.group = group
            
            return cell
        }
        else if indexPath.section == 0 && indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! SingleLabelCollectionViewCell
            cell.collectionView = collectionView
            cell.textLabel.text = group.longDescription
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! GroupDetailsProductCollectionViewCell
            
            cell.product = productCollection[indexPath.row]
            return cell
        }
        else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) as! GroupDetailsCollectionViewCell
            cell.backgroundColor = .blue
            
            reusableCell = cell
        }

        return reusableCell
    }

}

extension GroupDetailsViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        log.verbose("selected = \(indexPath.row)")
        
        if (indexPath.section != 1) { return }
        lastSelectedCell = collectionView.cellForItem(at: indexPath) as? GroupDetailsProductCollectionViewCell
        
        let controller = ProductViewController.fromStoryboard()
        controller.product = lastSelectedCell?.product
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


extension GroupDetailsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellSize : CGSize!
        let inset = Utils.insetSize
        let collectionWidth = Double(collectionView.frame.width - (GroupDetailsConstants.standardLeftInset + GroupDetailsConstants.standardRightInset))
        // Default: 2 cell per row
        var cellWidth = (collectionWidth - 10) / 2
        var cellHeight : Double = 1.4 * cellWidth
        
        if indexPath.section == 0 && indexPath.row == 0 {
            // First cell
            if topCellFrame != nil {
                cellWidth = Double(topCellFrame.width)
                cellHeight = Double(topCellFrame.height)
            }
            else {
                cellWidth = Double(collectionView.frame.width) // - (2 * inset)
                collectionView.cellForItem(at: IndexPath(row: 0, section: 0))
                cellHeight = 0.9 * cellWidth
            }
        }
        else if indexPath.section == 0 && indexPath.row == 1 {

            cellWidth = collectionWidth //- (2 * inset)
            let height : CGFloat!
            let widthWithInsets = CGFloat(cellWidth - (2 * inset))

            if let cell = collectionView.cellForItem(at: indexPath) as? SingleLabelCollectionViewCell {
                
                if cell.tag == 0 {
                    height = cell.textLabel.text?.height(constraintedWidth: widthWithInsets,
                                                               font: UIFont(name: cell.textLabel.font.fontName,
                                                                            size: cell.textLabel.font.pointSize)!)
                    
                    let animation : CATransition = CATransition()
                    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    animation.duration = 0.5
                    cell.textLabel.layer.add(animation, forKey: kCATransitionReveal)
                    
                }
                else {
                    height = cell.textLabel.text?.height(constraintedWidth: widthWithInsets,
                                                               font: UIFont(name: cell.textLabel.font.fontName,
                                                                            size: cell.textLabel.font.pointSize)!,
                                                               numberOfLines: 2)
                }
                
            } else {
                let font = UIFont(name: "AvenirNext-Regular", size: 16.0)
                height = group.longDescription.height(constraintedWidth: widthWithInsets,
                                                     font: font!,
                                                     numberOfLines: 2)
                
            }
            // Add to height the left and right cell insets (2 * 8) + some bufor
            cellHeight = Double(height) + 24
            
        }
//        else if indexPath.section == 1 {
//
//        }
        else {

        }
        
        cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var inset = UIEdgeInsets(top: GroupDetailsConstants.standardTopInset,
                                 left: GroupDetailsConstants.standardLeftInset,
                                 bottom: 20.0,
                                 right: GroupDetailsConstants.standardRightInset)
        if section == 0 {
            inset = UIEdgeInsets.zero
        }
        return inset
    }
    
}

class GroupDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var alphaView: UIView!
    
    // MARK: - Const/Vars
    var group : Group!
    var documentID : String!
    var topCellFrame : CGRect!
    
    private var productCollection : LocalCollection<Product>!
    private let sectionWithFirestoreData = 1
    
    var lastSelectedCell : GroupDetailsProductCollectionViewCell?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        
        //  Register custom section header
        collectionView.register(UINib(nibName: "SingleLabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "labelCell")
        collectionView.register(UINib(nibName: "GroupDetailsTopCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "groupCell")
        collectionView.register(UINib(nibName: "GroupDetailsProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "productCell")

        let query = Firestore.firestore().collection(Utils.collection.product.rawValue).whereField("parent_id", isEqualTo: group.id).order(by: "order")
        
        productCollection = LocalCollection(query: query, completionHandler: { [weak self] (documents, oldIDs) in
            
            guard let weakSelf = self else { return }
            if oldIDs.count == 0 {
                weakSelf.collectionView.reloadData()
                return
            }
            
            var addIndexPaths: [IndexPath] = []
            var delIndexPaths: [IndexPath] = []
            var modIndexPaths: [IndexPath] = []
            
            for document in documents {
                
                let id = document.document.documentID
                if weakSelf.productCollection.documentChanged(document: id) == false {
                    // Document didn't change. Nothing to do here
                    continue
                }
                if document.type == .added {
                    let indexPath = IndexPath(row: Int(document.newIndex), section: weakSelf.sectionWithFirestoreData)
                    if oldIDs.contains(document.document.documentID) == true {
                        modIndexPaths.append(indexPath)
                    }
                    else {
                        addIndexPaths.append(indexPath)
                    }
                }
                else if document.type == .removed {
                    let indexPath = IndexPath(row: Int(document.oldIndex), section: weakSelf.sectionWithFirestoreData)
                    delIndexPaths.append(indexPath)
                }
                else if document.type == DocumentChangeType.modified {
                    let modIndexPath = IndexPath(row: Int(document.oldIndex), section: weakSelf.sectionWithFirestoreData)
                    modIndexPaths.append(modIndexPath)
                }
            }
            
            // let's do this in batch to avoid crash
            weakSelf.collectionView.performBatchUpdates({
                weakSelf.collectionView.insertItems(at: addIndexPaths)
                weakSelf.collectionView.deleteItems(at: delIndexPaths)
                weakSelf.collectionView.reloadItems(at: modIndexPaths)

            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productCollection?.listen()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        productCollection?.stopListening()
    }
    
    deinit {
        log.debug("")
    }
    
    // MARK: - Methods
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> GroupDetailsViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "GroupDetailsViewController") as! GroupDetailsViewController
        return controller
    }
    
}

