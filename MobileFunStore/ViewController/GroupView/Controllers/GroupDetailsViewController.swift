
//  GroupDetailsViewController.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 25/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

extension GroupDetailsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        log.verbose("")

        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        log.verbose("numberOfItemsInSection")
        var itemInSection = 0
        if section == 0 {
            itemInSection = 1
        }
        return itemInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        log.verbose("cellForItemAt")
        var reusableCell : UICollectionViewCell!
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GroupDetailsTopCollectionViewCell
            cell.shortDecription.text = "short desc"
            
            cell.backgroundColor = .green
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) as! GroupDetailsCollectionViewCell
            cell.text.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTaped(_:)))
            cell.text.addGestureRecognizer(tapGesture)
            cell.backgroundColor = .orange

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
        let inset : Double = 5.0
        // Default: 2 cell per row
        var cellWidth : Double = (Double(collectionView.frame.width) - (3 * inset))/2
        if indexPath.section == 0 && indexPath.row == 0 {
            // One cell
            cellWidth = Double(collectionView.frame.width) - (2 * inset)
        }
        cellSize = CGSize(width: cellWidth, height: 1.7 * cellWidth)
        return cellSize
    }
        
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 2.0)
//    }
}

class GroupDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Const/Var
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = GroupDetailsCollectionViewLayout()
        self.tabBarController?.tabBar.isHidden = true

        //  Register custom section header
        collectionView.register(UINib(nibName: "GroupDetailsTopCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
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

