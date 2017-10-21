//
//  LocalCollection.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 18/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import FirebaseFirestore

protocol DocumentSerializable {
    
    init?(dictionary : [String : Any])
    func dictionary() -> [String : Any]
}

class LocalCollection<T: DocumentSerializable> {

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
    
    subscript(index: Int) -> T {
        return self.items[index]
    }
    
    func index(of document: DocumentSnapshot) -> Int? {
        for i in 0 ..< documents.count {
            if documents[i].documentID == document.documentID {
                return i
            }
        }
        
        return nil
    }
    
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
            let models = snapshot.documents.map({ (snapshot) -> T in
                log.verbose("\(snapshot.data())")
                guard let model = T(dictionary: snapshot.data()) else {
                    fatalError("Cannot parse snapshot data: \(snapshot.data())")
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


