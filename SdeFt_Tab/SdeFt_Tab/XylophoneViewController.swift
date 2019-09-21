//
//  XylophoneViewController.swift
//  SdeFt_Tab
//
//  Created by Focus on 21/09/19.
//  Copyright © 2019 Focus. All rights reserved.
//

import UIKit
import AVFoundation

class XylophoneViewController: UIViewController {
    
    var soundPlayer : AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    @IBAction func xyloButtonPressed(_ button: UIButton) {
        let soundList = ["xylo_c", "xylo_d1", "xylo_e1", "xylo_f", "xylo_g", "xylo_a", "xylo_b", "xylo_c2"]
        var soundName = ""
        
        if button.tag < soundList.count && button.tag >= 0 {
            soundName = soundList[button.tag]
        }
        
        if let soundResource = Bundle.main.url(forResource: soundName, withExtension: "wav"){
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: soundResource)
                
                soundPlayer?.play()
            } catch {
                print(error)
            }
        }
    }



}
