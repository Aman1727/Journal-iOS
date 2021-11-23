//
//  NoteViewController.swift
//  journalApp
//
//  Created by Aman on 23/11/21.
//

import UIKit

class NoteViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    @IBOutlet weak var starButton: UIButton!
    
    var note:Note?
    var notesModel:NotesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if note != nil {
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
            
//            Set the status of the star Button
            setStarButton()
        }else {
            //            This is a brand new note
            //            Create the note
                        
                        let n = Note(docId: UUID().uuidString, title: titleTextField.text ?? "No Title", body: bodyTextView.text, isStarred: false, createdAt: Date(), lastUpdatedAt: Date())
                        
                        self.note = n
        }
    }
    
    func setStarButton() {
        let imageName = note!.isStarred ? "star.fill" : "star"
        starButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        note = nil
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        if self.note != nil {
            notesModel?.deleteNote(self.note!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        
//            This is an update to the existing note
            self.note?.title = titleTextField.text ?? "No Title"
            self.note?.body = bodyTextView.text
            self.note?.lastUpdatedAt = Date()

        
        self.notesModel?.saveNote(self.note!)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func starTapped(_ sender: Any) {
        
//        Change the property in the note
        note?.isStarred.toggle()
//        Update the database
        notesModel?.updateFaveStatus(note!.docId, note!.isStarred)
//        Update the button
        
        setStarButton()
        
    }
    
    

}
