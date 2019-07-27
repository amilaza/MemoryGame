//
//  PlayAgainVC.swift
//  MemoryGame
//
//  Created by Nguyen Ba Linh on 4/4/19.
//  Copyright © 2019 Nguyen Ba Linh. All rights reserved.
//

import UIKit

class PlayAgainVC: UIViewController {

    @IBOutlet weak var lblStatus: UILabel!
    var isWin: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        if (isWin){
            handleWinTheGame()
        } else {
            handleLoseTheGame()
        }
    }
    
    func handleWinTheGame(){
        lblStatus.text = "You Win"
        // do something
    }
    
    func handleLoseTheGame(){
        lblStatus.text = "You Lose"
        // do something
    }
    
    @IBAction func touchPlayAgain(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
