//
//  ViewController.swift
//  LightSavor
//
//  Created by Aoyagi Naoto on 2018/08/05.
//  Copyright © 2018年 vertex. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation


class ViewController: UIViewController {
    
    let motionManager: CMMotionManager = CMMotionManager()
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    var startAudioPlayer: AVAudioPlayer = AVAudioPlayer()

    var startAccel:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSound()
        
    }
    
    @IBAction func tappedStartButton(_ sender: UIButton) {
        startAudioPlayer.play()
        startGetAcceleremoter()
        
        //let sound = Bundle.main.path(forResource: "light_saber1", ofType: ".mp3")
    }
    
    func setupSound() {
        // ボタンを押した時の音
        if let sound = Bundle.main.path(forResource: "light_saber1", ofType: ".mp3") {
            startAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            startAudioPlayer.prepareToPlay()
        }
        
        // iPhoneを振った時の音
        if let sound = Bundle.main.path(forResource: "light_saber3", ofType: ".mp3") {
            audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            audioPlayer.prepareToPlay()
        }
    }
    func startGetAcceleremoter(){
         // 加速度センサーの検出間隔
        motionManager.accelerometerUpdateInterval = 1 / 100
        
        // 検出開始と検出後の処理
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (accelerometerData: CMAccelerometerData?, error: Error?) in
            
            if let acc = accelerometerData {
                let x = acc.acceleration.x
                let y = acc.acceleration.y
                let z = acc.acceleration.z
                let synthetic = (x * x) + (y * y) + (z * z)
                
                if self.startAccel == false && synthetic >= 8{
                    self.audioPlayer.currentTime = 0
                    self.audioPlayer.play()
                }
                
                //降っている最中から速度が一定以下になった場合
                if self.startAccel == true && synthetic<1{
                    self.startAccel = false
                }
            }
        }



    }
  }
