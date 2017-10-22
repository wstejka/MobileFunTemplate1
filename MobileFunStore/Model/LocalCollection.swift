//
//  LocalCollection.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 18/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import FirebaseFirestore

struct DocumentIdentifiableComponent {
    var documentID : String = ""
}
    
protocol DocumentIdentifiable {
    var documentIdentifiableComponent : DocumentIdentifiableComponent { get set }
}

extension DocumentIdentifiable {

    var documentID : String {
        get {
            return documentIdentifiableComponent.documentID
        }
        set {
            documentIdentifiableComponent.documentID = newValue
        }
    }

}

protocol DocumentSerializable {
    
    init?(dictionary : [String : Any])
    func dictionary() -> [String : Any]
    
}


class LocalCollection<T: DocumentSerializable> {

    // MARK - Vars/Cons
    private(set) var items : [T] = []
    fileprivate let completionHandler : Utils.CompletionType
    fileprivate(set) var query : Query
    fileprivate(set) var documents: [DocumentSnapshot] = []
    
    var listener : FIRListenerRegistration? {
        didSet {
            oldValue?.remove()
        }
    }
    
    var count: Int {
        return self.items.count
    }
    
    // MARK: - methods
    subscript(index: Int) -> T {
        return self.items[index]
    }

//    // Get particular snapshot for given index
//    func getSnapshot(for index : Int) -> DocumentSnapshot? {
//
//    }
    
//    func index(of document: DocumentSnapshot) -> Int? {
//        for i in 0 ..< documents.count {
//            if documents[i].documentID == document.documentID {
//                return i
//            }
//        }
//
//        return nil
//    }
    
    init(query: Query, completionHandler : @escaping Utils.CompletionType) {
        self.items = []
        self.query = query
        self.completionHandler = completionHandler
    }
    
    func listen() {
        log.verbose("")
        guard listener == nil else { return }
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            
            guard let snapshot = snapshot else {
                log.error("Error fetching snapshot: \(String(describing: error))")
                return
            }
            let models = snapshot.documents.map({ (singlesnapshot) -> T in
                log.verbose("\(singlesnapshot.data())")
                guard let model = T(dictionary: singlesnapshot.data()) else {
                    fatalError("Cannot parse snapshot data: \(singlesnapshot.data())")
                }
                return model
            })
            self.items = models
            self.documents = snapshot.documents
            self.completionHandler(snapshot.documentChanges)
        }
    }
    
    func stopListening() {
        guard let listener = listener else { return }
        listener.remove()
        self.listener = nil
    }
    
    func getDocuments() {
        log.verbose("")
        query.getDocuments { [weak self] (snapshot, error) in
            guard let snapshot = snapshot else {
                log.error("Error fetching snapshot: \(String(describing: error))")
                return
            }
            let documents = snapshot.documents.map({ (snapshot) -> T in
                guard let document = T(dictionary: snapshot.data()) else {
                    fatalError("Cannot parse snapshot data: \(snapshot.data())")
                }
                return document
            })
            self?.items = documents
            self?.completionHandler(snapshot.documentChanges)
        }
    }
    
    deinit {
        stopListening()
    }
}


