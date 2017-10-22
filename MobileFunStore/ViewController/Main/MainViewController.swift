//
//  ViewController.swift
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
extension MainViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        log.verbose("entered: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        cell.selectionStyle = .none
        
        let group = groupCollection[indexPath.row]
        cell.titleLabel.text = group.title
        cell.descriptionLabel.text = group.description
        cell.imageViewHandler.image = nil
        
        let imageUrl = URL(string: group.url)
        cell.imageViewHandler.sd_setImage(with: imageUrl)
        
        return cell
    }
}

// MARK: - Extension UITableViewDataSource
extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        log.verbose("selected = \(indexPath.row)")
        
    }
}

// MARK: -
class MainViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Const/Var
    var groupCollection : LocalCollection<Group>!
    var groupsReference : DocumentReference?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - class lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        self.tableView.refreshControl = self.refreshControl
        
        let query = Firestore.firestore().collection("Groups").order(by: "id")
        groupCollection = LocalCollection(query: query, completionHandler: { [unowned self] (documents) in
            
            _ = documents.map({ print("\(String(describing: $0))") })
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        groupCollection.stopListening()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods
    
    @objc func handleRefresh() {
        
        DispatchQueue.global().async {
            log.verbose("")
            sleep(5)
            DispatchQueue.main.async { [unowned self] in
                log.verbose("")
                self.refreshControl.endRefreshing()
            }
        }
    }
}


