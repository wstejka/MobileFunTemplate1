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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupCell
        cell.selectionStyle = .none
        cell.tableWidth = tableView.frame.width
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
        let selectedCell = tableView.cellForRow(at: indexPath) as? GroupCell
        if group.final == false {
            let controller = GroupViewController.fromStoryboard()

            controller.query = Firestore.firestore().collection(Utils.collection.group.rawValue).order(by: "order").whereField("parent_id", isEqualTo: documentID)
            controller.navigationItem.leftBarButtonItem = nil
            controller.documentID = documentID
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            
            
            let controller = GroupDetailsViewController.fromStoryboard()
            controller.group = group
            controller.documentID = documentID
            controller.topCellFrame = selectedCell?.frame

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
    
    // MARK: - class lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        self.tableView.refreshControl = self.refreshControl
                
        groupCollection = LocalCollection(query: query, completionHandler: { [weak self] (documents, oldIDs) in
            
            guard let weakSelf = self else { return }
            if oldIDs.count == 0 {
                weakSelf.tableView.reloadData()
                return
            }

            var addIndexPaths: [IndexPath] = []
            var delIndexPaths: [IndexPath] = []
            var modIndexPaths: [IndexPath] = []

            for document in documents {
                
                let id = document.document.documentID
                if weakSelf.groupCollection.documentChanged(document: id) == false {
                    // Document didn't change. Nothing to do here
                    continue
                }
                
                if document.type == .added {
                    let indexPath = IndexPath(row: Int(document.newIndex), section: 0)
                    if oldIDs.contains(id) == true {
                        modIndexPaths.append(indexPath)
                    }
                    else {
                        addIndexPaths.append(indexPath)
                    }
                }
                else if document.type == .removed {
                    let indexPath = IndexPath(row: Int(document.oldIndex), section: 0)
                    delIndexPaths.append(indexPath)
                }
                else if document.type == DocumentChangeType.modified {
                    let indexPath = IndexPath(row: Int(document.oldIndex), section: 0)
                    modIndexPaths.append(indexPath)
                }
            }
            
            // let's do this in batch to avoid crash
            weakSelf.tableView.performBatchUpdates({
                weakSelf.tableView.insertRows(at: addIndexPaths, with: .automatic)
                weakSelf.tableView.deleteRows(at: delIndexPaths, with: .automatic)
                weakSelf.tableView.reloadRows(at: modIndexPaths, with: .automatic)
            })
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupCollection?.listen()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        groupCollection?.stopListening()
    }
    
    deinit {
        log.verbose("")
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


