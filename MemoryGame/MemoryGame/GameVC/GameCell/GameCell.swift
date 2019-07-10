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
    var gameItem: HideImage?

    var isOpened: Bool? {
        willSet{
            if newValue == true {
                imvItem.image = gameItem?.image
            } else {
                imvItem.image = UIImage(named: "ic_question_purple")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isOpened = false
    }

}
