//
//  FlashCardSetDetailActivity.swift
//  CS422L
//
//  Created by Jonathan Sligh on 2/3/21.
//

import Foundation
import UIKit
import CoreData

class FlashCardSetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    var parentSet = FlashcardSet()
    @IBOutlet var buttonView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var studyButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        tableView.addGestureRecognizer(longPressedGesture)
        makeItPretty()
    }
    
    // load flashcard sets from database
    func fetchCards() -> [Flashcard] {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Flashcard")
        do {
            return try managedContext.fetch(fetchRequest) as! [Flashcard]
        } catch {
            print("error fetching")
            return []
        }
    }
    
    //adds card
    @IBAction func addCard(_ sender: Any) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Flashcard", into: managedContext) as! Flashcard
        newCard.term = "Term \(parentSet.cards?.count ?? 0 + 1)"
        newCard.definition = "Definition \(parentSet.cards?.count ?? 0 + 1)"
        parentSet.addToCards(newCard)
        do { try managedContext.save() } catch { print("error adding Flashcard") }
        tableView.reloadData()
    }
    
    @IBAction func simulateDelete(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
                return
            }

        let p = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: p) {
            createCustomAlert(cardIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentSet.cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! FlashcardTableViewCell
        cell.flashcardLabel.text = (parentSet.cards![indexPath.row] as! Flashcard).term
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = parentSet.cards![indexPath.row] as! Flashcard
        let alert = UIAlertController(title: card.term, message: card.definition, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            self.createCustomAlert(cardIndex: indexPath.row)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func createCustomAlert(cardIndex: Int)
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let alertVC = sb.instantiateViewController(identifier: "EditAlertViewController") as! EditAlertViewController
        alertVC.parentVC = self
        alertVC.card = parentSet.cards![cardIndex] as! Flashcard
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: false, completion: nil)
    }
    
    //just a function to make everything look nice
    func makeItPretty()
    {
        buttonView.layer.cornerRadius = 8.0
        buttonView.layer.borderColor = UIColor.purple.cgColor
        buttonView.layer.borderWidth = 2.0
        deleteButton.layer.cornerRadius = 8.0
        studyButton.layer.cornerRadius = 8.0
        addButton.layer.cornerRadius = 8.0
    }
    
    // NOT NECESSARY FOR LAB 5
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (parentSet.cards != nil) {
            if let dest = segue.destination as? StudySetViewController {
                dest.referenceSet = parentSet.cards!.array as! [Flashcard]
            }
        }
    }
}
