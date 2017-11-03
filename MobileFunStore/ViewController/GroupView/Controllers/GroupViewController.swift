//
//  GroupViewController.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 09/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
import FirebaseFirestore
import Firebase


// MARK: - Extension UITableViewDataSource
extension GroupViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        log.verbose("entered: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupTableViewCell
        cell.selectionStyle = .none
        cell.group = groupCollection[indexPath.row]            
        return cell
    }
}

// MARK: - Extension UITableViewDataSource
extension GroupViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        log.verbose("selected = \(indexPath.row)")
        
        // Present selected group subview (if exist) or product view (if doesn't exist)
        // for now we have only groupviewcontroller :D
        let group = self.groupCollection[indexPath.row]
        let documentID = self.groupCollection.getDocumentID(for: indexPath.row)
        let selectedCell = tableView.cellForRow(at: indexPath) as? GroupTableViewCell
        if group.final == false {
            let controller = GroupViewController.fromStoryboard()

            controller.query = Firestore.firestore().collection(GroupStatics.collection.group.rawValue).order(by: "order").whereField("parent_id", isEqualTo: documentID)
            //query.document(documentID).collection(subgroupID)
            controller.navigationItem.leftBarButtonItem = nil
            controller.documentID = documentID
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = GroupDetailsViewController.fromStoryboard()
            controller.group = group
            controller.documentID = documentID
            controller.topCellFrame = selectedCell?.frame

//            let animation : CATransition = CATransition()
//            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            animation.duration = 0.5
//            self.navigationController?.view.layer.add(animation, forKey: kCATransitionFromTop)

//            let transition:CATransition = CATransition()
//            transition.duration = 0.5
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFromLeft
//            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(controller, animated: true)

        }
    }
}

// MARK: -
class GroupViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alphaView: UIView!
    
    // MARK: Const/Var
    var groupCollection : LocalCollection<Group>!
    let subgroupID = "subgroup"
    var documentID : String = ""
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    lazy var query = {
        return Firestore.firestore().collection("Groups").order(by: "order").whereField("parent_id", isEqualTo: "")
    }()
    
    var initialRequest : Bool = true
    
    // MARK: - class lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
//        self.navigationController?.delegate = NavDelegate()
        
        self.tableView.refreshControl = self.refreshControl
                
        groupCollection = LocalCollection(query: query, completionHandler: { [unowned self] (documents) in
            
            if self.initialRequest == true {
                self.initialRequest = false
                self.tableView.reloadData()
                return
            }
            
            var addIndexPaths: [IndexPath] = []
            var delIndexPaths: [IndexPath] = []

            for document in documents {
                if document.type == .added {
                    let indexPath = IndexPath(row: Int(document.newIndex), section: 0)
                    addIndexPaths.append(indexPath)
                }
                else if document.type == .removed {
                    let indexPath = IndexPath(row: Int(document.oldIndex), section: 0)
                    delIndexPaths.append(indexPath)
                }
                else if document.type == DocumentChangeType.modified {
                    let newIndexPath = IndexPath(row: Int(document.newIndex), section: 0)
                    let oldIndexPath = IndexPath(row: Int(document.oldIndex), section: 0)
                    addIndexPaths.append(newIndexPath)
                    delIndexPaths.append(oldIndexPath)

                }
            }
            // let's do this in batch to avoid crash
            self.tableView.performBatchUpdates({
                self.tableView.insertRows(at: addIndexPaths, with: .automatic)
                self.tableView.deleteRows(at: delIndexPaths, with: .automatic)
            })
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupCollection.listen()
        self.tabBarController?.tabBar.isHidden = false
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        log.verbose("")
        if groupCollection != nil {
            groupCollection.stopListening()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods
    
    @objc func handleRefresh() {
        
        DispatchQueue.global().async {
            log.verbose("")
            sleep(1)
            DispatchQueue.main.async { [unowned self] in
                log.verbose("")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> GroupViewController {
        let controller = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as! GroupViewController
        return controller
    }
}


