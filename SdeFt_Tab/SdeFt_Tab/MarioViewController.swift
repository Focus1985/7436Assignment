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

    
    @IBOutlet weak var GameSwitch: UISwitch!
    
    var BGSound = AVAudioPlayer()
    var WinSound = AVAudioPlayer()
    
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
    
    //Switch Button, Controls all actions
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
    
    @IBAction func Flag(_ sender: UIButton) {
        if (GameSwitch.isOn)
        {
            fullStop()
            GameSwitch.setOn(false, animated: true)
            WinSound.play()
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
        else{ return }
    }
    
    func Play(){
        BGSound.play()
        effectReady = true
    }
    
    func Stop(){
        BGSound.stop()
        effectReady = false
    }
    
    func fullStop(){
        Stop()
        BGSound.currentTime = 0
    }
    
    
   
    

}
