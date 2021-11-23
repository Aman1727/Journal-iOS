//
//  ViewController.swift
//  journalApp
//
//  Created by Aman on 23/11/21.
//

import UIKit

class ViewController: UIViewController {

    private var isStarFiltered = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var starButton: UIBarButtonItem!
    var notes = [Note]()
    private var notesModel = NotesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notesModel.delegate = self
        
        setStarFilterButton()
        
//        Retrieve all notes according to the filter status
        if isStarFiltered {
            notesModel.getNotes(true)
        }
        else {
            notesModel.getNotes()
        }
        
    }
    
    func setStarFilterButton() {
        //        Set the status of the star filter button
                let imageName = isStarFiltered ? "star.fill":"star"
                starButton.image = UIImage(systemName: imageName)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        notesModel.getNotes()
//    }
//

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let notesViewController = segue.destination as! NoteViewController
        
        if tableView.indexPathForSelectedRow != nil {
            notesViewController.note = notes[tableView.indexPathForSelectedRow!.row]
            //        Deselect the selected row
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
//        Whether its a new note or a selected note, we still want to pass through the notes model
        notesViewController.notesModel = self.notesModel
        

    }
    
    @IBAction func startFilterTapped(_ sender: Any) {
        
//        Toggle the star filter status
        isStarFiltered.toggle()
        
//        Run the query
        if isStarFiltered {
            notesModel.getNotes(true)
        }
        else {
            notesModel.getNotes()
        }
//        Update the star button
        setStarFilterButton()
    }
    


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
//        Modify the cell
        let titleLabel = cell.viewWithTag(1) as? UILabel
        titleLabel?.text = notes[indexPath.row].title
        
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        bodyLabel?.text = notes[indexPath.row].body
        
        
        return cell
    }
    
    
}

extension ViewController:NotesModelProtocol {
    func notesRetrieved(notes: [Note]) {
        self.notes = notes
        tableView.reloadData()
    }
}


extension ViewController: UITableViewDelegate {
    
    
}

