//
//  ViewController.swift
//  ros-controller
//
//  Created by David Mattia on 4/1/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import CoreMotion
import Firebase

public extension Double {
    func roundToDecimals(decimals: Int = 2) -> Double {
        let multiplier = Double(10^decimals)
        return round(multiplier * self) / multiplier
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    let motionManager : CMMotionManager! = CMMotionManager()
    let motionRef = Firebase(url:"https://ros.firebaseio.com/speed")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if motionManager.accelerometerAvailable{
            self.textLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0))
            
            let queue = NSOperationQueue()
            motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data, error) in
                let pitch = data!.attitude.pitch
                let roll = data!.attitude.roll
                
                let motion = [
                    "linear": (roll + M_PI_2).roundToDecimals(2),
                    "angular": pitch.roundToDecimals(2)
                ]
                if self.activeSwitch.on {
                    self.motionRef.setValue(motion)
                }
            })
        } else {
            self.textLabel.text = "Accelerometer data is not available."
            print("Accelerometer is not available")
        }
    }
}

