//
//  ViewController.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let bounds = UIScreen.mainScreen().bounds

    @IBOutlet weak var arcBG: ArcView!
    @IBOutlet weak var startButton: SqueezeButton!
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    var soundBiteTitles = ["Just do it", "Don't let your dreams be dreams", "Make your dreams come true", "Just do it", "Nothing is Impossible", "What are you waiting for?", "Do it", "Just do it. Yes you can.", "Stop. Giving. Up."]
    
    var running = false
    
    var speechPlayer: SpeechPlayer!
    
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var saysLabel: UILabel!
    
    var standardTimer: NSTimer!
    
    @IBOutlet weak var dataChart: Chart!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var elapsedTimer: NSTimer?
    
    @IBOutlet weak var heartImageView: UIImageView!
    var locationData = [(x: 0.0, y: 0.0)]
    var startDate: NSDate!
    
    @IBOutlet weak var headImageView: UIImageView!
    var minutes = 0
    var seconds = 0
    
    var motionController: MotionController!
    var locationController: LocationController!
    var healthController: HealthController!
    
    var xV: XView!
    var shrunk = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        speechPlayer = SpeechPlayer(delegate: self)
        let bgView = BackgroundView(frame: bounds)
        view.insertSubview(bgView, atIndex: 0)
        
        startButton.layer.cornerRadius = 6
        
        xV = XView(frame: bounds)
        xV.alpha = 0
        view.addSubview(xV)
        
        quoteLabel.adjustsFontSizeToFitWidth = true
        
        let series = ChartSeries(data: [(x: 0.0, y: 0.0)])
        series.color = UIColor.whiteColor()
        dataChart.addSeries(series)
        dataChart.backgroundColor = UIColor(white: 1, alpha: 0.3)
        dataChart.gridColor = UIColor.whiteColor()
        dataChart.axesColor = UIColor.whiteColor()
        dataChart.labelColor = UIColor.whiteColor()
        dataChart.lineWidth = 3
        dataChart.highlightLineColor = UIColor.whiteColor()
        dataChart.userInteractionEnabled = false
        animateHeartWithRate(60)
        
        
        motionController = MotionController(delegate: self)
        locationController = LocationController(noteDelegate: self)
        healthController = HealthController(delegate: self)
    }
    
    

    
    override func viewDidAppear(animated: Bool) {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = UIBezierPath(arcCenter: headImageView.center, radius: 4, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: false).CGPath
        anim.duration = 4
        anim.repeatCount = HUGE
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        headImageView.layer.addAnimation(anim, forKey: "position")
    }
    
    func updateQuoteLabelWithSoundIndex(i: Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.quoteLabel.alpha = 0.0
                }) { (done) -> Void in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.quoteLabel.text = "\"\(self.soundBiteTitles[i])\""
                        self.quoteLabel.alpha = 1.0
                    })
            }
        })
    }
    
    func updateTime() {
        seconds++
        if seconds == 60 {
            seconds = 0
            minutes++
        }
        timeLabel.text = String(format: "Elapsed Time: %02d:%02d", arguments: [minutes, seconds])
    }


    @IBAction func startPressed(sender: AnyObject) {
        running = !running
        
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            self.dataChart.removeSeries()
//            let series2 = ChartSeries(data: [(x: 5, y: 10), (x: 6, y: 5.2), (x: 7, y: 7.3)])
//            self.dataChart.addSeries(series2)
//            self.dataChart.setNeedsDisplay()
//        }
        
        if running {
            let titles = ["Give up", "Quit Forever", "Quit", "Dreams lost", "I'm too weak"]
            let title = titles[Int(random() % titles.count)]
            startButton.setTitle(title, forState: .Normal)
            startButton.backgroundColor = UIColor.redColor()
            startButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            elapsedTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
            motionController.start()
            locationController.startUpdatingLocation()
            startDate = NSDate()
            locationController.totalDistance = 0
            
            //watch out not to clear the info
            let series = ChartSeries(data: [(x: 0.0, y: 0.0)])
            series.color = UIColor.whiteColor()
            dataChart.addSeries(series)
        } else {
            startButton.setTitle("Start Workout", forState: .Normal)
            startButton.backgroundColor = UIColor.whiteColor()
            startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            updateQuoteLabelWithSoundIndex(3)
            elapsedTimer?.invalidate()
            motionController.stop()
            setSufficient()
            locationController.stopUpdatingLocation()
        }
    }

    //stuff
    func setSufficient() {
        UIView.animateWithDuration(1) { () -> Void in
            self.xV.alpha = 0
        }
    }
    func setInSufficient() {
        UIView.animateWithDuration(1) { () -> Void in
            self.xV?.alpha = 1
        }
        speechPlayer.newQuote()
    }
    
    func updateSteps() {
       stepsLabel.text = "Steps: \(motionController.stepCount)"
    }
    
    func updateDistance() {
        let x = NSDate().timeIntervalSinceDate(startDate)
        let y = locationController.totalDistance
        locationData.append((x: x, y: y))
        dataChart.removeSeries()
        let ser = ChartSeries(data: locationData)
        ser.color = UIColor.whiteColor()
        dataChart.addSeries(ser)
        dataChart.setNeedsDisplay()
    }
    
    func animateHeartWithRate(rate: Float) {
        bpmLabel.text = "\(Int(rate))"
        let beatTime = NSTimeInterval(60 / rate)
        print("new rate is: \(rate)")
        //let inTime = NSTimeInterval(0.8 * beatTime)
        //let outTime = NSTimeInterval(0.2 * beatTime)
        
        UIView.animateKeyframesWithDuration(beatTime, delay: 0, options: UIViewKeyframeAnimationOptions.Repeat, animations: { () -> Void in
            //in
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.7, animations: { () -> Void in
                self.heartImageView.transform = CGAffineTransformScale(self.heartImageView.transform, 0.9, 0.9)
            })
            //out
            UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: { () -> Void in
                self.heartImageView.transform = CGAffineTransformScale(self.heartImageView.transform, 1/0.9, 1/0.9)
            })
            
            }, completion: nil)
    }
    
}

