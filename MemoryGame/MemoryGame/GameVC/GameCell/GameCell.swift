//
//  GameCell.swift
//  MemoryGame
//
//  Created by Nguyen Ba Linh on 3/3/19.
//  Copyright © 2019 Nguyen Ba Linh. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {

    @IBOutlet weak var imvItem: UIImageView!
    var gameItem: HideImage?{
        willSet{
            //imvItem.image = newValue?.image
            //gameItem = newValue
        }
    }
    
    var imageTemp: UIImage?{
        willSet {
            imvItem.image = newValue
        }
    }
    
    var isOpened: Bool? {
        willSet{
            isOpened = newValue
            if isOpened ?? true {
                imvItem.image = gameItem?.image
            } else {
                imvItem.image = imageTemp;
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageTemp = UIImage(named: "ic_question_purple")
    }

}
