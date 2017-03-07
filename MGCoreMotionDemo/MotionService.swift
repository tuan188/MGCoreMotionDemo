//
//  MotionService.swift
//  MGCoreMotionDemo
//
//  Created by Tuan Truong on 3/7/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import CoreMotion

protocol MotionServiceDelegate: class {
    func motionServiceUpdateStatus(status: String, value: Double)
}

class MotionService: NSObject {
    
    let roundingPrecision = 3
    
    var accelerometerDataInEuclidianNorm: Double = 0
    var accelerometerDataCount: Double = 0
    var totalAcceleration: Double = 0
    var accelerometerDataInASecond = [Double]()
    let staticThreshold = 0.02
    let slowWalkingThreshold = 0.1
    var pedestrianStatus = ""
    
    weak var delegate: MotionServiceDelegate?
    
    func estimatePedestrianStatus(acceleration: CMAcceleration) {
        // Obtain the Euclidian Norm of the accelerometer data
        accelerometerDataInEuclidianNorm = sqrt((acceleration.x.roundTo(roundingPrecision) * acceleration.x.roundTo(roundingPrecision)) + (acceleration.y.roundTo(roundingPrecision) * acceleration.y.roundTo(roundingPrecision)) + (acceleration.z.roundTo(roundingPrecision) * acceleration.z.roundTo(roundingPrecision)))
        
        // Significant figure setting
        accelerometerDataInEuclidianNorm = accelerometerDataInEuclidianNorm.roundTo(roundingPrecision)
        
        // record 10 values
        // meaning values in a second
        // accUpdateInterval(0.1s) * 10 = 1s
        while accelerometerDataCount < 1 {
            accelerometerDataCount += 0.1
            
            accelerometerDataInASecond.append(accelerometerDataInEuclidianNorm)
            totalAcceleration += accelerometerDataInEuclidianNorm
            
            break   // required since we want to obtain data every acc cycle
        }
        
        // when acc values recorded
        // interpret them
        if accelerometerDataCount >= 1 {
            accelerometerDataCount = 0  // reset for the next round
            
            // Calculating the variance of the Euclidian Norm of the accelerometer data
            let accelerationMean = (totalAcceleration / 10).roundTo(roundingPrecision)
            var total: Double = 0.0
            
            for data in accelerometerDataInASecond {
                total += ((data-accelerationMean) * (data-accelerationMean)).roundTo(roundingPrecision)
            }
            
            total = total.roundTo(roundingPrecision)
            
            let result: Double = (total / 10).roundTo(roundingPrecision)
            print("Result: \(result)")
            
            if (result < staticThreshold) {
                pedestrianStatus = "Static"
            } else if ((staticThreshold < result) && (result <= slowWalkingThreshold)) {
                pedestrianStatus = "Slow Walking"
            } else if (slowWalkingThreshold < result) {
                pedestrianStatus = "Fast Walking"
            }
            
            print("Pedestrian Status: \(pedestrianStatus)\n---\n\n")
            
            delegate?.motionServiceUpdateStatus(status: pedestrianStatus, value: result)
            
            // reset for the next round
            accelerometerDataInASecond = []
            totalAcceleration = 0.0
        }
    }
}
