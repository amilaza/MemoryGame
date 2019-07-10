//
//  GameVC.swift
//  MemoryGame
//
//  Created by Nguyen Ba Linh on 3/2/19.
//  Copyright © 2019 Nguyen Ba Linh. All rights reserved.
//

import UIKit
import LinearProgressBar
import AudioPlayer

class GameVC: UIViewController {

    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var viewLevel: UIView!
    @IBOutlet weak var btnMute: UIButton!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var sliderCountDown: LinearProgressBar!
    @IBOutlet weak var clvGame: UICollectionView!
    @IBOutlet weak var lblScore: UILabel!
    
    
//    var gameItems:[HideImage] = []
    var height: CGFloat = 0.0
    var width: CGFloat = 0.0
    let MAIN_SCREEN: CGRect = UIScreen.main.bounds
    var previourIndexPath: IndexPath?
    var selectedIndexPaths:[IndexPath]? = []
    var gameScene: GameScene = GameScene()
    var audioPlayer: AudioPlayer?
    var coundownTime: Double = 1
    var scores: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        //loadDatas()
        loadUIs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isMute = UserDefaults.standard.bool(forKey: "isMute")
        btnMute.isSelected = isMute
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //initGame()
        gameScene.loadGameWithLevel(level: 1)
        height = clvGame.frame.height/CGFloat(gameScene.row)
        width = clvGame.frame.width/CGFloat(gameScene.column)
        clvGame.reloadData()
        coundownTime = gameScene.time!
        
    }
    
    func loadDatas(){
        if let listScore:[Int] = UserDefaults.standard.array(forKey: "HighestScore") as? [Int]{
            scores = listScore
        }
        
        selectedIndexPaths?.removeAll()
        previourIndexPath = nil
        
        do {
            audioPlayer = try AudioPlayer(fileName: "audio_click.wav")
            
        } catch {
            print("Sound initialization failed")
        }
        
    }
    
    func initGame(){
        gameScene.loadGameWithLevel(level: gameScene.level)
        selectedIndexPaths?.removeAll()
        lblLevel.text = "Level \(gameScene.level)"
        //loadScene()
        sliderCountDown.progressValue = 100
        startCountDown();
    }
    
    @objc func startCountDown(){
        if (coundownTime.isLess(than: 0)){
            loseTheGame()
            //loadNextScene()
        } else {
            self.perform(#selector(reduceTimer), with: nil, afterDelay: 1)
        }
    }
    
    @objc func reduceTimer(){
        let progress = 100 * coundownTime / gameScene.time!
        sliderCountDown.progressValue = CGFloat(progress)
        coundownTime = coundownTime - 1
        print("---------------     \(coundownTime)")
        startCountDown()
    }
    
//    func loadScene(){
//
//        gameScene.loadGameWithLevel(level: 1)
//        height = clvGame.frame.height/CGFloat(gameScene.row)
//        width = clvGame.frame.width/CGFloat(gameScene.column)
//        clvGame.reloadData()
//        coundownTime = gameScene.time!
//        //loadGame()
//    }
    
    func loadUIs(){
        clvGame.delegate = self;
        clvGame.dataSource = self;
        registerCollectionView();
        viewLevel.layer.cornerRadius = 4
        viewScore.layer.cornerRadius = 4
        sliderCountDown.backgroundColor = UIColor.clear
    }
    
    func registerCollectionView(){
        let nib: UINib = UINib(nibName: "GameCell", bundle: nil);
        clvGame.register(nib, forCellWithReuseIdentifier: "GameCell")
        
    }
    
    func loadGame(){
        clvGame.reloadData()
    }
    
    func loadNextScene(){
        if (gameScene.column == 8 && gameScene.row == 8){
            winThegame()
            return;
        }
        gameScene.level = gameScene.level + 1
        initGame()
    }
    
    func winThegame(){
        saveTheScore()
//        let vc: WinTheGameVC = WinTheGameVC()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func saveTheScore(){
        if(scores.count == 0){
            scores.append(gameScene.score)
            UserDefaults.standard.set(scores, forKey: "HighestScore")
            return
        }
        
        if scores.last! > gameScene.score {
            return
        }
        
        reoderTheScores()
    }
    
    func reoderTheScores(){
        for score in scores {
            if score <= gameScene.score {
                scores.insert(gameScene.score, at: (scores.index(of: score))!)
                UserDefaults.standard.set(scores, forKey: "HighestScore")
            }
        }
        
        if scores.count > 5 {
            scores.removeLast()
        }
    }
    
    func loseTheGame(){
        saveTheScore()
        let numberOfGame:Int = UserDefaults.standard.integer(forKey: "numberOfGame")
        if (numberOfGame % 3 == 2){
           // showAdmob()
        }
        
        if (numberOfGame > 1000){
            updateNumberOfGame(games: 1)
        } else {
            updateNumberOfGame(games: numberOfGame + 1)
        }

//        let vc: PlayAgainVC = PlayAgainVC()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resetGame(){
        gameScene.level = 1
        gameScene.score = 0
        self.initGame()
    }
    
    func updateNumberOfGame(games: Int){
        UserDefaults.standard.setValue(games, forKey: "numberOfGame")
    }
    
    @IBAction func touchBack(_ sender: Any) {
        let alertController = UIAlertController(title: "Oop!", message: "The game will be reset.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Back", style: .default) { (action:UIAlertAction) in
           self.navigationController?.popToRootViewController(animated: true)
        }
        
        let action2 = UIAlertAction(title: "Stay", style: .cancel) { (action:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func touchMute(_ sender: Any) {
        btnMute.isSelected = !btnMute.isSelected
        UserDefaults.standard.set(btnMute.isSelected, forKey: "isMute")
    }
    
}

extension GameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameScene.column * gameScene.row;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GameCell = clvGame.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
//        cell.gameItem = gameScene.gameItems[indexPath.row];
//        if (!(selectedIndexPaths?.contains(indexPath))!){
//            cell.isOpened = false;
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath == previourIndexPath){
            return;
        }
        
//        let currentCell: GameCell = clvGame.cellForItem(at: indexPath) as! GameCell
//        currentCell.isOpened = true;
//        if(!btnMute.isSelected){
//            audioPlayer?.play()
//        }
        
       self.perform(#selector(handleClickItemAt(indexPath:)), with: indexPath, afterDelay: 1)
    }
    
    @objc func handleClickItemAt(indexPath: IndexPath) {
        
        let currentCell: GameCell = clvGame.cellForItem(at: indexPath) as! GameCell
        
//        if let preIndexPath = previourIndexPath{
//            let preCell: GameCell = clvGame.cellForItem(at: preIndexPath) as! GameCell
//            if (currentCell.gameItem?.imageID == preCell.gameItem?.imageID){
//                currentCell.isOpened = true
//                preCell.isOpened = true
//                previourIndexPath = nil
//                selectedIndexPaths?.append(indexPath)
//                selectedIndexPaths?.append(preIndexPath)
//                
//                gameScene.score = gameScene.score + 1
//                lblScore.text = "Score: \(gameScene.score)"
//                
//                if (selectedIndexPaths?.count == gameScene.row * gameScene.column){
//                    loadNextScene()
//                }
//            } else {
//                currentCell.isOpened = false
//                previourIndexPath = indexPath
//            }
//        } else {
//            currentCell.isOpened = false
//            previourIndexPath = indexPath
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: height)
    }
}

