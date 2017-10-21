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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        
        let group = groupCollection[indexPath.row]
        cell.titleLabel.text = group.description
        cell.imageViewHandler.image = nil
        
        let imageUrl = URL(string: group.url)
        cell.imageViewHandler.sd_setImage(with: imageUrl) { (image, error, cache, url) in
            
            log.verbose("HURRa: \(cache.rawValue)")
        }
        
        return cell
    }
}

// MARK: - Extension UITableViewDataSource
extension MainViewController : UITableViewDelegate {
    
}

// MARK: -
class MainViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Const/Var
    var groupCollection : LocalCollection<Group>!
    var groupsReference : DocumentReference?
    
    // MARK: - class lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
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
                    self.tableView.moveRow(at: oldIndexPath, to: newIndexPath)
                }
            }
            if addIndexPaths.count > 0 {
                self.tableView.insertRows(at: addIndexPaths, with: .automatic)
            }
            if delIndexPaths.count > 0 {
                self.tableView.deleteRows(at: delIndexPaths, with: .automatic)
            }            
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

}


