//
//  File.swift
//  journalApp
//
//  Created by Aman on 23/11/21.
//

import Foundation
import Firebase

protocol NotesModelProtocol {
    func notesRetrieved(notes:[Note])
}


class NotesModel {
    
    var delegate:NotesModelProtocol?
    
    var listener:ListenerRegistration?
    
    deinit {
//        Unregister database listener
        listener?.remove()
    }
    
    func getNotes(_ starredOnly:Bool = false) {
         
        
//        Detech any listener
        listener?.remove()
        
        
//        Get the reference of the database
        let db = Firestore.firestore()
        
        
        var query:Query = db.collection("notes")
//        If we're only looking for starred notes, update the query

        if starredOnly {
            query = query.whereField("isStarred", isEqualTo: true)
        }
        
        
        self.listener =  query.addSnapshotListener { snapshot, error in
            if error == nil && snapshot != nil {
                var notes = [Note]()
                //                Parse doucments into notes
                for doc in snapshot!.documents {
                    
                    let createdAtDate = Timestamp.dateValue(doc["createdAt"] as! Timestamp)()
                    
                    let lastUpdatedDate = Timestamp.dateValue(doc["lastUpdatedAt"] as! Timestamp)()
                    
                    
                    let n = Note(docId: doc["docId"] as! String, title: doc["title"] as! String, body: doc["body"] as! String, isStarred: doc["isStarred"] as! Bool,  createdAt: createdAtDate, lastUpdatedAt: lastUpdatedDate)
                    
                    notes.append(n)
                }
                DispatchQueue.main.async {
                    self.delegate?.notesRetrieved(notes: notes)
                }
            }
        }
    }
    
    func deleteNote(_ n:Note) {
        let db = Firestore.firestore()
        db.collection("notes").document(n.docId).delete()
        
        
    }
    
    func saveNote(_ n:Note) {
        let db = Firestore.firestore()
        db.collection("notes").document(n.docId).setData(noteToDic(n))
    }
    
    func updateFaveStatus(_ docId:String, _ isStarred:Bool) {
        let db = Firestore.firestore()
        db.collection("notes").document(docId).updateData(["isStarred":isStarred])
    }
    
    func noteToDic(_ n:Note) -> [String: Any] {
        
        var dic = [String: Any]()
        dic["docId"] = n.docId
        dic["title"] = n.title
        dic["body"] = n.body
        dic["createdAt"] = n.createdAt
        dic["isStarred"] = n.isStarred
        dic["lastUpdatedAt"] = n.lastUpdatedAt
        
        return dic
    }
    
}

