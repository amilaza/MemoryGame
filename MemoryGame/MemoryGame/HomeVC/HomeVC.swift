//
//  HomeVC.swift
//  MemoryGame
//
//  Created by Nguyen Ba Linh on 3/2/19.
//  Copyright © 2019 Nguyen Ba Linh. All rights reserved.
//

import UIKit
import AudioPlayer
class HomeVC: UIViewController {

    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnMute: UIButton!
    var audioPlayer: AudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        initAudio()
        
        loadUIs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isMute = UserDefaults.standard.bool(forKey: "isMute")
        btnMute.isSelected = isMute
        
        if (audioPlayer == nil){
            initAudio()
        }
        registerNotification()
        playMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        turnOffTheMusic()
        audioPlayer?.stop()
        audioPlayer = nil
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //turnOffTheMusic()
    }
    
    func registerNotification(){
        removeNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(handleCompletion(_:)), name: AudioPlayer.SoundDidFinishPlayingNotification, object: nil)
    }
    
    func removeNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleCompletion(_ notification: Notification) {
        if((audioPlayer) != nil){
            turnOnTheMusic()
        }
    }
    
    func loadDatas(){
        if let scores = UserDefaults.standard.array(forKey: "HighestScore"){
            lblScore.text = "\(scores[0])"
        }
    }
    
    func loadUIs(){
        
    }
    
    func initAudio(){
        do {
            audioPlayer = try AudioPlayer(fileName: "audio_background.mp3")
            
        } catch {
            print("Sound initialization failed")
        }
    }
    func playMusic(){
        let isMute = UserDefaults.standard.bool(forKey: "isMute")
        if isMute {
            turnOffTheMusic()
        } else {
            turnOnTheMusic()
        }
    }
    
    @IBAction func touchPlay(_ sender: Any) {
        let vc: GameVC = GameVC();
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func touchMute(_ sender: Any) {
        btnMute.isSelected = !btnMute.isSelected
        if btnMute.isSelected {
            turnOffTheMusic()
        } else {
            turnOnTheMusic()
        }
        UserDefaults.standard.set(btnMute.isSelected, forKey: "isMute")
        
    }
    
    func turnOnTheMusic(){
        
        if((audioPlayer?.isPlaying)!){
            audioPlayer?.fadeIn()
        } else {
            audioPlayer?.play()
        }
    }
    
    func turnOffTheMusic(){
        if((audioPlayer?.isPlaying)!){
            audioPlayer?.fadeOut()
        } else {
            audioPlayer?.fadeOut()
        }
    }
    
}
