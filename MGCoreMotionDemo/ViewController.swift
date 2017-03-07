//
//  ViewController.swift
//  MGCoreMotionDemo
//
//  Created by Tuan Truong on 3/6/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct AccelerometerValue {
        var x: Double
        var y: Double
        var z: Double
        
        init(_ x: Double, _ y: Double, _ z: Double) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        func toString() -> String {
            let rx = String(format: "%02f", x)
            let ry = String(format: "%02f", y)
            let rz = String(format: "%02f", z)
            return "\(rx) \(ry) \(rz)"
        }
    }
    
    var values = [AccelerometerValue]()
    let motionManager = CMMotionManager()
    let motionService = MotionService()
    var statusList = [(String, Double)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        motionService.delegate = self
        motionManager.accelerometerUpdateInterval = 0.1
    }
    
    fileprivate func start() {
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (accelerometerData, error) -> Void in
            if((error) != nil) {
                print(error!)
            } else {
                self.motionService.estimatePedestrianStatus(acceleration: (accelerometerData!.acceleration))
            }
        }
    }
    
    @IBAction func start(_ sender: Any) {
        start()
//        motionKit.getAccelerometerValues(interval: 2) { [weak self](x, y, z) in
//            let value = AccelerometerValue(x, y, z)
//            self?.values.append(value)
//            self?.reloadData()
//            
//        }
    }
    
    fileprivate func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        motionManager.stopAccelerometerUpdates()
//        motionKit.stopAccelerometerUpdates()
    }
    
}

extension ViewController: MotionServiceDelegate {
    func motionServiceUpdateStatus(status: String, value: Double) {
        statusList.append((status, value))
        reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let value = values[indexPath.row]
//        cell.textLabel?.text = value.toString()
        let status = statusList[indexPath.row]
        cell.textLabel?.text = "\(status.0) \(status.1)"
        return cell
    }
}

