//
//  ResultController.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit

class ResultController: UIViewController {

    @IBOutlet weak var saveButton: SqueezeButton!
    @IBOutlet weak var discardButton: SqueezeButton!
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var legLabel: UILabel!
    var delegate: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.layer.cornerRadius = 6
        discardButton.layer.cornerRadius = 6
        
        headLabel.text = "Mental"
        heartLabel.text = "Belief"
        legLabel.text = "Strength"
    }

    
    @IBAction func savePressed(sender: AnyObject) {
        delegate.saveData()
        delegate.clearData()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.delegate.scrollView.contentOffset.x = 0
        })
    }

    @IBAction func discardPressed(sender: AnyObject) {
        delegate.clearData()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.delegate.scrollView.contentOffset.x = 0
        })
    }


}
