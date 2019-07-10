//
//  GameScene.swift
//  MemoryGame
//
//  Created by Nguyen Ba Linh on 3/25/19.
//  Copyright © 2019 Nguyen Ba Linh. All rights reserved.
//

import UIKit

class GameScene: NSObject {
    var time: Double?
    var level: Int = 1
    var column: Int = 1
    var row: Int = 1
    var score: Int = 0
    var gameItems:[HideImage] = []
    var openedGameItems:[HideImage] = []
    var itemManager: GameItems = GameItems()
    
    func loadGameWithLevel(level: Int){
        self.level = level
        switch level {
        case 1:
            loadFirstScene()
            break
    
        case 2:
            loadSecondScene()
            break
            
        default:
            loadFirstScene()
            break
        }
        
        time = Double(1.5 * Double(column * row))
        initGameItems()
    }
    
    private func initGameItems(){
        if (gameItems.isEmpty == false){
            gameItems.removeAll()
        }
        gameItems = itemManager.loadGameItemsWith(numberOfCouple: (column * row) / 2)
    }
    
    private func loadFirstScene(){
        column = 2
        row = 3
    }
    
    private func loadSecondScene(){
        column = 3
        row = 4
    }
    
}
