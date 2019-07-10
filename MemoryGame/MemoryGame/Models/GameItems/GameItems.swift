//
//  GameItems.swift
//  MemoryGame
//
//  Created by Nguyen Ba Linh on 3/6/19.
//  Copyright © 2019 Nguyen Ba Linh. All rights reserved.
//

import UIKit

class GameItems: NSObject {
    var gameItems:[HideImage] = []
    var fruitItems:[String] = []
    func loadGameItemsWith(numberOfCouple: Int)->[HideImage]{
        loadFruitItems()
        randomGameItems(with: numberOfCouple * 2);
        return gameItems;
    }
    
    private func randomGameItems(with numberItems:Int){
        var tempItem: [String] = []
        var numberOfItem = 0
        while numberOfItem < numberItems {
            let string: String = fruitItems.randomElement() ?? ""
            if (!tempItem.contains(string)){
                tempItem.append(string)
                numberOfItem = numberOfItem + 1
            }
        }
        tempItem.append(contentsOf: tempItem)
        tempItem.shuffle()
        
        gameItems.removeAll()
        for item in tempItem {
            let imageObj: HideImage = HideImage()
            imageObj.image = UIImage(named: item)
            imageObj.imageID = item
            imageObj.isOpen = false;
            gameItems.append(imageObj)
        }
    }
    
    private func loadFruitItems(){
        for item in 1...33{
            let imageObj: String = "ic_food_\(item)"
            fruitItems.append(imageObj)
        }
        
    }
}
