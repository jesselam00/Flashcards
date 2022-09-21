//
//  EditAlertViewController.swift
//  CS422L
//
//  Created by Jonathan Sligh on 2/18/21.
//

import UIKit

class EditAlertViewController: UIViewController {

    @IBOutlet var alertView: UIView!
    @IBOutlet var termEditText: UITextField!
    @IBOutlet var definitionEditText: UITextField!
    //card from FlashCardSetDetailViewController
    var card = Flashcard()
    //use this later to do things to the flashcards potentially
    var parentVC: FlashCardSetDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup()
    {
        alertView.layer.cornerRadius = 8.0
        //set term/def
        termEditText.text = card.term
        definitionEditText.text = card.definition
        //make it so it shows this is editable
        termEditText.becomeFirstResponder()
    }
    
    @IBAction func deleteFlashcard(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            managedContext.delete(self.card)
            do {
                try managedContext.save()
                self.parentVC?.parentSet.removeFromCards(self.card)
                self.parentVC?.tableView.reloadData()
            } catch {
                print("error deleting Flashcard")
            }
        })
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            self.card.term = self.termEditText.text
            self.card.definition = self.definitionEditText.text
            do {
                try managedContext.save()
                self.parentVC?.tableView.reloadData()
            } catch {
                print("error saving Flashcard")
                
            }
        })
    }
    
}
