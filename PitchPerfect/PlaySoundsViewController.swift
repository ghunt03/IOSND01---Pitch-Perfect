//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Gareth Hunt on 4/12/2015.
//  Copyright © 2015 ghunt03. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    
    var audioPLayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    var receivedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPLayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
            audioPLayer.enableRate = true
        } catch let error as NSError {
                           print(error.localizedDescription)
                    }
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func playAudio(playbackSpeed:Float) {
        audioPLayer.stop()
        audioPLayer.rate = playbackSpeed
        audioPLayer.currentTime = 0.0
        audioPLayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPLayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }

    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)

    }
    @IBAction func playSlow(sender: AnyObject) {
        playAudio(0.5)
    }
    @IBAction func playFast(sender: AnyObject) {
        playAudio(2.0)
    }
    @IBAction func stopAudio(sender: AnyObject) {
        audioPLayer.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
