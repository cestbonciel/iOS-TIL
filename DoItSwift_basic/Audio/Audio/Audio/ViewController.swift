//
//  ViewController.swift
//  Audio
//
//  Created by a0000 on 2022/08/16.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
	
	var audioPlayer: AVAudioPlayer!
	var audioFile: URL!
	let MAX_VOLUME: Float = 10.0
	var progressTimer: Timer!
	
	let timePlayerSelector: Selector = #selector(ViewController.updatePlayTime)
	let timeRecordSelector: Selector = #selector(ViewController.updateRecordTime)
	
	@IBOutlet weak var pvProgressPlay: UIProgressView!
	@IBOutlet weak var lblCurrentTime: UILabel!
	@IBOutlet weak var lblEndTime: UILabel!
	@IBOutlet weak var btnPlay: UIButton!
	@IBOutlet weak var btnPause: UIButton!
	@IBOutlet weak var btnStop: UIButton!
	@IBOutlet weak var slVolume: UISlider!
	@IBOutlet weak var buttonRecord: UIButton!
	@IBOutlet weak var lblRecordTime: UILabel!
	
	var audioRecorder: AVAudioRecorder!
	var isRecordMode = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		selectAudioFile()
		if !isRecordMode {
			initPlay()
			buttonRecord.isEnabled = false
			lblRecordTime.isEnabled = false
		} else {
			initRecord()
		}
	}
	
	func selectAudioFile() {
		if !isRecordMode {
			audioFile = Bundle.main.url(forResource: "Sicilian_Breeze", withExtension: "mp3")
		} else {
			let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
			audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
		}
	}
	
	func initRecord() {
		let recordSettings = [
			AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless as UInt32),
			AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
			AVEncoderBitRateKey: 320000,
			AVNumberOfChannelsKey: 2,
			AVSampleRateKey: 44100.0] as [String: Any]
		do {
			audioRecorder = try AVAudioRecorder(url: audioFile, settings: recordSettings)
		} catch let error as NSError {
			print("Error-initRecord: \(error)")
		}
		
		audioRecorder.delegate = self
		
		slVolume.value = 1.0
		audioPlayer.volume = slVolume.value
		lblEndTime.text = convertNSTimeInterval2String(0)
		setPlayButton(false, pause: false, stop: false)
		
		let session = AVAudioSession.sharedInstance()
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)
		} catch let error as NSError {
			print("Error-setCategory:\(error)")
		}
		do {
			try session.setActive(true)
		} catch let error as NSError {
			print("Error-setActive: \(error)")
		}
	}
	
	func initPlay(){
		do{
			audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
		} catch let error as NSError {
			print("Error-initPlay: \(error)")
		}
		slVolume.maximumValue = MAX_VOLUME
		slVolume.value = 1.0
		pvProgressPlay.progress = 0
		
		audioPlayer.delegate = self
		audioPlayer.prepareToPlay()
		audioPlayer.volume = slVolume.value
		
		lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
		lblCurrentTime.text = convertNSTimeInterval2String(0)
		setPlayButton(true, pause: false, stop: false)
	}
	
	func setPlayButton(_ play: Bool, pause: Bool, stop: Bool){
		btnPlay.isEnabled = play
		btnPause.isEnabled = pause
		btnStop.isEnabled = stop
	}
	
	func convertNSTimeInterval2String(_ time: TimeInterval) -> String{
		let min = Int(time/60)
		let sec = Int(time.truncatingRemainder(dividingBy: 60))
		let strTime = String(format:"%02d:%02d", min, sec)
		return strTime
	}
	
	@IBAction func btnPlayAudio(_ sender: UIButton) {
		audioPlayer.play()
		setPlayButton(false, pause: true, stop: true)
		progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
	}
	
	@IBAction func btnPauseAudio(_ sender: UIButton) {
		audioPlayer.pause()
		setPlayButton(true, pause: false, stop: true)
	}
	
	@IBAction func btnStopAudio(_ sender: UIButton) {
		audioPlayer.stop()
		audioPlayer.currentTime = 0
		lblCurrentTime.text = convertNSTimeInterval2String(0)
		setPlayButton(true, pause: true, stop: false)
		progressTimer.invalidate()
	}
	
	@IBAction func slChangeVolume(_ sender: UISlider) {
		audioPlayer.volume = slVolume.value
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		progressTimer.invalidate()
		setPlayButton(true, pause: false, stop: false)
	}
	
	@objc func updatePlayTime(){
		lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
		pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
	}
	
	@objc func updateRecordTime() {
		lblRecordTime.text = convertNSTimeInterval2String(audioRecorder.currentTime)
	}
	
	@IBAction func swRecordMode(_ sender: UISwitch) {
		if sender.isOn {
			audioPlayer.stop()
			audioPlayer.currentTime = 0
			lblRecordTime!.text = convertNSTimeInterval2String(0)
			isRecordMode = true
			buttonRecord.isEnabled = true
			lblRecordTime.isEnabled = true
		} else {
			isRecordMode = false
			buttonRecord.isEnabled = false
			lblRecordTime.isEnabled = false
			lblRecordTime.text = convertNSTimeInterval2String(0)
		}
		selectAudioFile()
		if !isRecordMode {
			initPlay()
		} else {
			initRecord()
		}
	}
	
	
	@IBAction func tapButtonRecord(_ sender: UIButton) {
		if (sender as AnyObject).titleLabel?.text == "Record" {
			audioRecorder.record()
			(sender as AnyObject).setTitle("stop", for: UIControl.State())
			progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
		} else {
			audioRecorder.stop()
			(sender as AnyObject).setTitle("Record", for: UIControl.State())
			btnPlay.isEnabled = true
			initPlay()
		}
	}
	
}

