//
//  FlashCardSetCollectionCell.swift
//  CS422L
//
//  Created by Jonathan Sligh on 2/3/21.
//

import Foundation
import UIKit

class FlashcardSetCollectionCell: UICollectionViewCell
{
    @IBOutlet var bottomView: UIView!
    @IBOutlet var middleView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var textLabel: UILabel!
    
    //just makes it look pretty
    func setup()
    {
        bottomView.layer.cornerRadius = 8.0
        middleView.layer.cornerRadius = 8.0
        topView.layer.cornerRadius = 8.0
    }
    
}
