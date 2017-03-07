//
//  DoubleExtension.swift
//  MGCoreMotionDemo
//
//  Created by Tuan Truong on 3/7/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

extension Double {
    func roundTo(_ precision: Int) -> Double {
        let divisor = pow(10.0, Double(precision))
        return (self * divisor).rounded() / divisor
    }
}
