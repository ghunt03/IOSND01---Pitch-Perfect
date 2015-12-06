//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Gareth Hunt on 4/12/2015.
//  Copyright © 2015 ghunt03. All rights reserved.
//

import UIKit
import AVFoundation
class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    //initialising button and label outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    //variables for the handling of the audio recording
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        recordLabel.text = "Tap to record"
        pauseButton.hidden = true
        resumeButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            //if recording was finished successfully save details in RecordedAudio object and call segue to next screen
            recordedAudio = RecordedAudio(filePath: recorder.url, title:recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }
        else {
            //if the recording did not finish successfully alert user
            let alertController = UIAlertController(title: "Pitch Perfect", message:
                "There was a problem with the recording", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            //move to next screen and pass RecordedAudio object
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: AnyObject) {
        //stops recording
        stopButton.hidden = true
        recordLabel.text = "Tap to record"
        recordButton.enabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func pauseRecording(sender: AnyObject) {
        pauseResumeRecording()
    }
    
    @IBAction func resumeRecording(sender: AnyObject) {
        pauseResumeRecording()
    }
    
    func pauseResumeRecording() {
        //function to allow the user to pause / resume the recording
        if (audioRecorder.recording) {
            audioRecorder.pause()
            recordLabel.text = "Recording paused"
            pauseButton.hidden = true
            resumeButton.hidden = false
        }
        else {
            audioRecorder.record()
            recordLabel.text = "Recording in progress"
            pauseButton.hidden = false
            resumeButton.hidden = true
        }
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        //update label and show pause / stop button
        recordLabel.text = "Recording in progress"
        stopButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        
        //sets the file path for the recorded audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //initiates recording session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //starts recording
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
}
