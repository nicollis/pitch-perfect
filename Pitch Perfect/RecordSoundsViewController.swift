//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nic Ollis on 5/1/17.
//  Copyright © 2017 Ollis. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    enum RecordingState { case recording, notRecording }

    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notRecording)
    }

    @IBAction func recordAudio(_ sender: Any) {
        configureUI(.recording)
        recordAudioControls(.recording)
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.notRecording)
        recordAudioControls(.notRecording)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print ("recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // Logic to enable and disable recording
    func recordAudioControls(_ recordingState: RecordingState) {
        switch recordingState {
        case .recording:
            //Start recording
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let filePath = URL(string: [dirPath, "recordedVoice.wav"].joined(separator: "/"))
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings:[:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        case .notRecording:
            //Stop recording
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        }
    }
    
    func configureUI(_ recording: RecordingState) {
        switch recording {
        case .recording:
            recordingLabel.text = "Recording in Progress"
            stopRecordingButton.isEnabled = true
            recordingButton.isEnabled = false
        case .notRecording:
            recordingLabel.text = "stop recording button was pressed"
            stopRecordingButton.isEnabled = false
            recordingButton.isEnabled = true
        }
    }

}

