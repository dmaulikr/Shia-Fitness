//
//  SpeechPlayer.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechPlayer: NSObject {
    var player: AVAudioPlayer!
    
    var soundBiteIndex = 0
    var soundBiteTimes = [(3.5,7.5), (8.5,11.5), (11.5,18.3), (18.3,20.5), (22.5,28.9), (30.5,41.5), (42,46.5), (47,48.7), (53, 58.3)]
    
    var standardTimer: NSTimer!
    
    var stopTimer: NSTimer?
    
    var delegate: ViewController!
    
    init(delegate: ViewController) {
        super.init()
        self.delegate = delegate
        let path = NSBundle.mainBundle().pathForResource("speech", ofType: "caf")
        let URL = NSURL(fileURLWithPath: path!)
        player = try! AVAudioPlayer(contentsOfURL: URL, fileTypeHint: "caf")
        player.prepareToPlay()
        playQuoteWithSoundIndex(1)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
        } catch {
            
        }
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            
        }
        
        standardTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("newQuote"), userInfo: nil, repeats: true)
    }
    
    func newQuote() {
        soundBiteIndex++
        if soundBiteIndex + 1 == soundBiteTimes.count {
            soundBiteIndex = 0
        }
        delegate.updateQuoteLabelWithSoundIndex(soundBiteIndex)
        playQuoteWithSoundIndex(soundBiteIndex)
    }

    func playQuoteWithSoundIndex(i: Int) {
        let startStop = soundBiteTimes[soundBiteIndex]
        let startTime = startStop.0
        let stopTime = startStop.1
        player.currentTime = startTime
        stopSpeechAtTime(stopTime)
        player.play()
    }
    
    func pauseSpeech() {
        player.pause()
    }
    
    func stopSpeechAtTime(t: NSTimeInterval) {
        if (stopTimer?.valid == true) {
            stopTimer?.invalidate()
        }
        let waitTime = t - player.currentTime
        stopTimer = NSTimer.scheduledTimerWithTimeInterval(waitTime, target: self, selector: Selector("pauseSpeech"), userInfo: nil, repeats: false)
    }
    
    
}
