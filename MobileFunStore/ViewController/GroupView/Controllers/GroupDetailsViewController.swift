
//  GroupDetailsViewController.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 25/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import FirebaseFirestore

extension GroupDetailsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        log.verbose("")

        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        log.verbose("numberOfItemsInSection")
        var itemInSection = 0
        if section == 0 {
            itemInSection = 2
        }
        return itemInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        log.verbose("cellForItemAt")
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
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) as! GroupDetailsCollectionViewCell
//            cell.backgroundColor = .orange

            reusableCell = cell
        }
        
        return reusableCell
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reusableCell", for: indexPath)
//        
//        return reusableView
//    }
}

extension GroupDetailsViewController : UICollectionViewDelegate {

    @objc func labelTaped(_ sender: UITapGestureRecognizer) {
        log.verbose("Tap gesture recognizer")
    }
}


extension GroupDetailsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellSize : CGSize!
        let inset = GroupStatics.insetSize
        let collectionWidth : Double = Double(collectionView.frame.width)
        // Default: 2 cell per row
        var cellWidth : Double = (Double(collectionView.frame.width) - (3 * inset))/2
        var cellHeight : Double = 1.4 * cellWidth
        
        if indexPath.section == 0 && indexPath.row == 0 {
            // One cell
            cellWidth = collectionWidth - (2 * inset)
            cellHeight = 0.9 * cellWidth
        }
        else if indexPath.section == 0 && indexPath.row == 1 {

            cellWidth = collectionWidth - (2 * inset)
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
        
        cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 5.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
}

class GroupDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Const/Var
    var group : Group!
    var documentID : String!
    
    private var productCollection : LocalCollection<Product>!
    
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

//        Firestore.firestore().collection(GroupStatics.collection.group.rawValue).document(documentID)
//            .getDocument { [weak self] (snapshot, erorr) in
//            
//                guard let weakSelf = self else { return }
//                weakSelf.group = Group(dictionary: snapshot!.data())
//                // TODO: Requests here for products wired up with the document
//                
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if productCollection != nil {
            productCollection.stopListening()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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

