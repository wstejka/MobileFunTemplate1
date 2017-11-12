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

// MARK: - protocol DataEquatable

protocol DocumentEquatable : Equatable {
    var uniqueKey : String { get }
    func documentChanged(document : Self) -> Bool
}

extension DocumentEquatable {
    
    static func ==(rhs : Self, lhs: Self) -> Bool {
        return rhs.uniqueKey == lhs.uniqueKey ? true : false
    }
}

// MARK: - protocol DocumentSerializable

protocol DocumentSerializable {
    
    init?(dictionary : [String : Any])
    func dictionary() -> [String : Any]
    
}

class LocalCollection<T: DocumentSerializable> where T : DocumentEquatable {

    // MARK - Vars/Cons
    private(set) var items : [T] = []
    private var oldItemsDict : [String : T] = [:]
    private var itemsDict : [String : T] = [:]
    fileprivate let completionHandler : ModelUtils.CompletionType
    fileprivate(set) var query : Query
    fileprivate(set) var documents: [DocumentSnapshot] = []
    
    var listener : ListenerRegistration? {
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
    var getItems: [T] {
        return self.items
    }

    // Get documentID
    func getDocumentID(for index : Int) -> String {
        return documents[index].documentID
    }
    
    init(query: Query, completionHandler : @escaping ModelUtils.CompletionType) {
        self.items = []
        self.query = query
        self.completionHandler = completionHandler
    }
    
    func listen() {
        guard listener == nil else { return }
        log.verbose("")

        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            
            guard let snapshot = snapshot else {
                log.error("Error fetching snapshot: \(String(describing: error))")
                return
            }
            let oldIDs = self.items.map({ (document) -> String in
                return document.uniqueKey
            })
            self.oldItemsDict = self.getDict(fromArray: self.items)
            
            let models = snapshot.documents.map({ (singlesnapshot) -> T in
//                log.verbose("\(singlesnapshot.data())")
                guard let model = T(dictionary: singlesnapshot.data()) else {
                    fatalError("Cannot parse snapshot data: \(singlesnapshot.data())")
                }
                return model
            })
            self.items = models
            self.itemsDict = self.getDict(fromArray: self.items)

            self.documents = snapshot.documents
            self.completionHandler(snapshot.documentChanges, oldIDs)
        }
    }

    private func getDict(fromArray : [T]) -> [String : T] {
        
        let itemsDict = fromArray.reduce([String : T]()) { (prevDict, object) -> [String : T] in
            
            var prevDict = prevDict
            prevDict[object.uniqueKey] = object
            return prevDict
        }
        return itemsDict
    }
    
    func documentChanged(document id : String) -> Bool {
        
        guard let oldDocument = oldItemsDict[id] else {
            return true
        }
        guard let newDocument = itemsDict[id] else {
            return true
        }
        return oldDocument.documentChanged(document: newDocument)
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
            self?.completionHandler(snapshot.documentChanges, [])
        }
    }
    
    deinit {
        stopListening()
    }
}


