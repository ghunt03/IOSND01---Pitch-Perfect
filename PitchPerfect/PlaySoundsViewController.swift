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

    //initialising button outlets
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthvaderButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    
    //variables for the handling of the audio playback
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    //variable containing details about file received from recording view controller
    var receivedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func playAudioWithEffect(effectType: String) {
        //private function for playing audio with effects on pitch or speed
        audioEngine.stop()
        audioEngine.reset()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let changeEffect = AVAudioUnitTimePitch()
        switch effectType {
            case "slow":
                changeEffect.rate = 0.5
            case "fast":
                changeEffect.rate = 2.0
            case "chipmunk":
                changeEffect.pitch = 1000
            case "darthvader":
                changeEffect.pitch = -1000
            default:
                changeEffect.rate = 1.0
                changeEffect.pitch = 1.0
        }
        audioEngine.attachNode(changeEffect)
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    private func playAudioWithSpecialEffect(effectType:String) {
        //private function for adding special effects to playback including echo and reverb
        audioEngine.stop()
        audioEngine.reset()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        if (effectType=="echo") {
            //Add echo effect to playback
            let echoEffect = AVAudioUnitDistortion()
            echoEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho1)
            audioEngine.attachNode(echoEffect)
            audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
            audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        }
        if (effectType == "reverb") {
            //Add reverb effect with cathedral preset
            let reverb = AVAudioUnitReverb()
            reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
            reverb.wetDryMix = 50
            audioEngine.attachNode(reverb)
            audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
            audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        }
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
        
    }
    
    //button actions
    @IBAction func playEchoAudio(sender: AnyObject) {
        playAudioWithSpecialEffect("echo")
    }
    
    @IBAction func playRevebAudio(sender: AnyObject) {
        playAudioWithSpecialEffect("reverb")
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithEffect("darthvader")
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithEffect("chipmunk")
    }
    
    @IBAction func playSlow(sender: AnyObject) {
        playAudioWithEffect("slow")
    }
    
    @IBAction func playFast(sender: AnyObject) {
        playAudioWithEffect("fast")
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioEngine.stop()
    }
}
