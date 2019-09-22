//
//  MarioViewController.swift
//  SdeFt_Tab
//
//  Created by Focus on 21/09/19.
//  Copyright © 2019 Focus. All rights reserved.
//

import UIKit
import AVFoundation

class MarioViewController: UIViewController {

    //this outlet allows to read the switch status, and to manipulate the toggle action of the switch. When the user triggers the game ending sequences, the switch can be turned off for the user.
    @IBOutlet weak var GameSwitch: UISwitch!
    
    var BGSound = AVAudioPlayer()
    var WinSound = AVAudioPlayer()
    var LoseSound = AVAudioPlayer()
    
    var soundEffect : AVAudioPlayer?
    var effectReady = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //prepare the background music, unwrap the mp3 file path string, catch any error that the compiler throws
        
        do{
            BGSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "BGMusic", ofType: "mp3")!))
            BGSound.prepareToPlay()
            WinSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "StageClear", ofType: "mp3")!))
            WinSound.prepareToPlay()
            LoseSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "fail", ofType: "mp3")!))
            WinSound.prepareToPlay()
        }
        
        catch
        {
            print(error)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    //Switch Button, Controls all actions. User will manually turn it on to "play" the Super Mario game.
    @IBAction func GameStart(_ sender: UISwitch) {
        if (sender.isOn == true)
        {
            Play()
            BGSound.numberOfLoops = -1

            
        }
        else
        {
            fullStop()
        }
    }
    
    // The pause button linked with Toggles funcion that allows the sound can be paused, instead of starting from the beginning
    @IBAction func Pause(_ sender: UIButton) {
        toogle()
        
    }
    
    // This simulates the game experience of stage clear, when the user touches the flag, a stage is cleared. the AutoLayout is really tricky, I have to learn more to control the flag's position.
    @IBAction func Flag(_ sender: UIButton) {
        if (GameSwitch.isOn)
        {
            fullStop()
            GameSwitch.setOn(false, animated: true)
            WinSound.play()
        }
    }
    
    //The user tapped the Bomshell, means the Mario has met his unfortunated fate, the losing tune is played. Only works if the main switch is on.
    @IBAction func Lose(_ sender: UIButton) {
        if (GameSwitch.isOn)
        {
            fullStop()
            GameSwitch.setOn(false, animated: true)
            LoseSound.play()
        }
    }
    
    // Actions allow user to do the Mario tricks only after the game is on.
    @IBAction func SoundEffects(_ sender: UIButton) {
        if (effectReady == true){
            let soundList = ["hitBricks", "gotTreasure", "getPowerUp", "getCoin", "EnterTunnel", "jump"]
            var soundName = ""
            
            if sender.tag < soundList.count && sender.tag >= 0 {
                soundName = soundList[sender.tag]
            }
            
            if let soundResource = Bundle.main.url(forResource: soundName, withExtension: "mp3"){
                do {
                    soundEffect = try AVAudioPlayer(contentsOf: soundResource)
                    
                    soundEffect?.play()
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    

    
    //MARK:- Helper Functions
    func toogle (){
        // check if the background sound is still playing, then the stop order has a meaning, otherwise resume from the pause.
        if (GameSwitch.isOn){
            if(BGSound.isPlaying)
            {
                Stop()
            }
            else
            {
                Play()
            }
        }
        // if the game is not "running", this action has no meaning but to return.
        else{ return }
    }
    
    //this function simulates the FC game play experience, allows the user to do all the game trick, such as hitting bricks, get coins as well as to win or lose.
    func Play(){
        BGSound.play()
        effectReady = true
    }
    
    //An action to provide easy calling for Pause, during the pause, the background music stays resumable, all other sound buttons are "disabled".
    func Stop(){
        BGSound.stop()
        effectReady = false
    }
    
    //An action function simulates the game ending
    func fullStop(){
        Stop()
        BGSound.currentTime = 0
    }

    

}


