//
//  ViewController.swift
//  MotionSurvey2
//
//  Created by memsql on 2/3/16.
//  Copyright © 2016 Princeton. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    private var locMgr = CLLocationManager()
    private var geo = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locMgr.delegate = self
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        
        locMgr.requestWhenInUseAuthorization() // for foreground
       // locMgr.requestAlwaysAuthorization() // for background
        
        /*if (CLLocationManager.locationServicesEnabled()) {
            locMgr.startMonitoringSignificantLocationChanges();
        } else {
            print("Location services not enabled, please enable this in your Settings");
        }
        */
    }
    
    @IBAction func getFixPressed(sender: AnyObject) {
        locMgr.requestLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
}

