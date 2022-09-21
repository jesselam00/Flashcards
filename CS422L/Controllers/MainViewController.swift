//
//  ViewController.swift
//  CS422L
//
//  Created by Jonathan Sligh on 1/29/21.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet var collectionView: UICollectionView!
    var sets: [FlashcardSet] = [FlashcardSet]()
    var selectedSet: FlashcardSet = FlashcardSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sets = fetchSets()
        collectionView.delegate = self
        collectionView.dataSource = self
        makeThingsLookPretty()
    }
    
    // load flashcard sets from database
    func fetchSets() -> [FlashcardSet] {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlashcardSet")
        do {
            return try managedContext.fetch(fetchRequest) as! [FlashcardSet]
        } catch {
            print("error fetching")
            return []
        }
    }

    @IBAction func addNewSet(_ sender: Any) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newSet = NSEntityDescription.insertNewObject(forEntityName: "FlashcardSet", into: managedContext) as! FlashcardSet
        newSet.title = "Title \(sets.count + 1)"
        do { try managedContext.save() } catch { print("error adding FlashcardSet") }
        sets.append(newSet)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetCell", for: indexPath) as! FlashcardSetCollectionCell
        //setup method just makes it look nice
        cell.setup()
        cell.textLabel.text = sets[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //go to new view
        selectedSet = sets[indexPath.row]
        performSegue(withIdentifier: "GoToDetail", sender: self)
    }
    
    //another function to make things look nice
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 2   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
    //just a function to make things look nice
    func makeThingsLookPretty()
    {
        let margin: CGFloat = 10
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    // FOR BONUS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? FlashCardSetDetailViewController {
            dest.parentSet = selectedSet
        }
    }
}

