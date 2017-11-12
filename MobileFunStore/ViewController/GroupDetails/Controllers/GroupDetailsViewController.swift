
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


class GroupDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var alphaView: UIView!
    
    // MARK: - Const/Vars
    var items : [GroupDetailsViewModel] = []
    var group : Group! {
        didSet {
            let collectionWidth = UIScreen.main.bounds.size.width
            let imageViewModel = GDImagesViewModel(group: group, collectionWidth : collectionWidth)
            
            let titleLabel = LabelModel(text: group.title, font: UIFont.avenir(name: .demiBold, size: 19.0), defaultLines : 0)
            let shortDesc = LabelModel(text: group.shortDescription, font: UIFont.avenir(name: .regular, size: 15.0), defaultLines : 2)
            let longDesc = LabelModel(text: group.longDescription, font: UIFont.avenir(name: .regular, size: 16.0))
            let textViewModel = GDTextViewModel(items: [titleLabel, shortDesc, longDesc], collectionWidth : collectionWidth)

            let productsViewModel = GDProductsViewModel(products: [], collectionWidth : collectionWidth)
            let bottomViewModel = GDBottomViewModel(collectionWidth : collectionWidth)
            items = [imageViewModel, textViewModel] //, productsViewModel, bottomViewModel]
        }
    }
    var documentID : String!
    var topCellFrame : CGRect!
    
    private var productCollection : LocalCollection<Product>!
    private let sectionWithFirestoreData = 1
    
    var lastSelectedCell : GroupDetailsProductCell?
    
    func indexOfItem(type : GroupDetailsSectionType) -> Int? {        
        let index = items.index(where: { (item) -> Bool in item.type == type })
        return index?.hashValue
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        
        //  Register custom section header
        collectionView.register(UINib(nibName: "GroupDetailsImageCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        collectionView.register(UINib(nibName: "GroupDetailsLabelCell", bundle: nil), forCellWithReuseIdentifier: "labelCell")
        collectionView.register(UINib(nibName: "GroupDetailsProductCell", bundle: nil), forCellWithReuseIdentifier: "productCell")

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
            flowLayout.minimumLineSpacing = 0.0
        }
        
        let query = Firestore.firestore().collection(Utils.collection.product.rawValue).whereField("parent_id", isEqualTo: group.id).order(by: "order")
        productCollection = LocalCollection(query: query, completionHandler: { [weak self] (documents, oldIDs) in
            
            guard let weakSelf = self else { return }
            guard let productSectionIndex = weakSelf.indexOfItem(type: .products),
                let productViewModel = weakSelf.items[productSectionIndex] as? GDProductsViewModel else {
                log.error("Cannot unwrap product section index")
                return
            }
            // Update ViewModel with [Product] delivered by the productCollection
            weakSelf.items[productSectionIndex] = GDProductsViewModel(products: weakSelf.productCollection.getItems,
                                                                      collectionWidth: productViewModel.collectionWidth)
            
            
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
                    let indexPath = IndexPath(row: Int(document.newIndex), section: productSectionIndex)
                    if oldIDs.contains(document.document.documentID) == true {
                        modIndexPaths.append(indexPath)
                    }
                    else {
                        addIndexPaths.append(indexPath)
                    }
                }
                else if document.type == .removed {
                    let indexPath = IndexPath(row: Int(document.oldIndex), section: productSectionIndex)
                    delIndexPaths.append(indexPath)
                }
                else if document.type == DocumentChangeType.modified {
                    let modIndexPath = IndexPath(row: Int(document.oldIndex), section: productSectionIndex)
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
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "GroupDetails", bundle: nil)) -> GroupDetailsViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "GroupDetailsViewController") as! GroupDetailsViewController
        return controller
    }
    
}


// MARK: - Extensions

extension GroupDetailsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        log.verbose("")
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        log.verbose("numberOfItemsInSection")
        
        return items[section].elementsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.section]
        switch item.type {
        case .image:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? GroupDetailsImageCell {
                cell.item = item
                return cell
            }
        case .label:
            if let viewModel = item as? GDTextViewModel,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as? GroupDetailsLabelCell {
                cell.item = viewModel[indexPath.row]
                return cell
            }
        case .products:
            if let viewModel = item as? GDProductsViewModel,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? GroupDetailsProductCell {
                cell.product = viewModel[indexPath.row]
                return cell
            }
        case .bottom:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) as! GroupDetailsCell
            cell.backgroundColor = .blue
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension GroupDetailsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        log.verbose("selected = \(indexPath.row)")
//        
//        if (indexPath.section != 1) { return }
//        lastSelectedCell = collectionView.cellForItem(at: indexPath) as? GroupDetailsProductCell
//        
//        let controller = ProductViewController.fromStoryboard()
//        controller.product = lastSelectedCell?.product
//        self.navigationController?.pushViewController(controller, animated: true)
    }
}


extension GroupDetailsViewController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let item = items[section]
        return item.sectionInset
    }
    
}


// MARK: - GroupDetailsSectionType

enum GroupDetailsSectionType : Int {
    case image
    case label
    case products
    case bottom
}

// MARK: - GroupDetailsViewModel protocol
protocol GroupDetailsViewModel {
    
    var title : String { get }
    var type : GroupDetailsSectionType { get }
    var elementsNumber : Int { get }
    var collectionWidth : CGFloat { get }
    var sectionInset : UIEdgeInsets { get }
}

extension GroupDetailsViewModel {
    
    var title : String {
        return "Header"
    }
    var elementsNumber : Int {
        return 1
    }
    var sectionInset : UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

// MARK: - View Models
//== IMAGE
class GDImagesViewModel : GroupDetailsViewModel {
    
    private static let inset : CGFloat = 8.0
    private static let bottomInset : CGFloat = 8.0
    var collectionWidth: CGFloat
    
    var type: GroupDetailsSectionType = .image
    // Let's width will be 1.5 greater than height
    let heightToWidthFactor : CGFloat = (1 / 1.5)

    var sectionInset: UIEdgeInsets {
        return UIEdgeInsets(top: GDImagesViewModel.inset, left: GDImagesViewModel.inset,
                            bottom: GDImagesViewModel.bottomInset, right: GDImagesViewModel.inset)
    }

    let group : Group
    init(group : Group, collectionWidth : CGFloat) {
        self.group = group
        self.collectionWidth = collectionWidth - (2 * GDImagesViewModel.inset)
    }
}

//== Title & descriptions
class GDTextViewModel : GroupDetailsViewModel {
    
    var collectionWidth: CGFloat
    private static let inset : CGFloat = 8.0
    var type: GroupDetailsSectionType = .label
    var elementsNumber : Int {
        return self.items.count
    }
    private var items : [LabelModel]
    subscript(index: Int) -> LabelModel {
        return self.items[index]
    }
    var sectionInset: UIEdgeInsets {
        return UIEdgeInsets(top: GDTextViewModel.inset, left: GDTextViewModel.inset,
                            bottom: 0.0, right: GDTextViewModel.inset)
    }

    init(items : [LabelModel], collectionWidth : CGFloat) {
        
        self.collectionWidth = collectionWidth
        self.items = items.enumerated().map({ (index, element) -> LabelModel in
            var modalElement = element
            modalElement.index = index
            modalElement.labelWidth = collectionWidth - (2 * GDTextViewModel.inset)
            return modalElement
        })
    }
}
//== Products
class GDProductsViewModel : GroupDetailsViewModel {
    
    private var products : [Product]
    private let leftInset = 10.0
    private let rightInset = 10.0
    var collectionWidth: CGFloat
    var type: GroupDetailsSectionType = .products
    var elementsNumber: Int {
        return products.count
    }
    
    subscript(index: Int) -> Product {
        return self.products[index]
    }
    
    init(products : [Product], collectionWidth : CGFloat) {
        self.products = products
        self.collectionWidth = collectionWidth
    }
}

//== Bottom
class GDBottomViewModel : GroupDetailsViewModel {
    
    var type: GroupDetailsSectionType = .bottom
    var collectionWidth: CGFloat
    
    init(collectionWidth : CGFloat) {
        self.collectionWidth = collectionWidth
    }
}






