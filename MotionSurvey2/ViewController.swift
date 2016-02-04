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

    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup locMgr
        //
        locMgr.delegate = self
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        
        // request permission to use locations
        //
        locMgr.requestWhenInUseAuthorization() // for foreground
        locMgr.requestAlwaysAuthorization() // for background
        
        //locMgr.allowDeferredLocationUpdatesUntilTraveled(20.0, timeout: 5)  // meters, seconds (?)
        
        // foreground only -- receive updates every 20 meters
        //
        locMgr.distanceFilter = 20 // meters
        locMgr.startUpdatingLocation()
        
       /* if (CLLocationManager.locationServicesEnabled()) {
            locMgr.startMonitoringSignificantLocationChanges();
        } else {
            print("Location services not enabled, please enable this in your Settings");
        }*/
    }
    
    @IBAction func getFixPressed(sender: AnyObject) {
        locMgr.requestLocation() // dosn't work if startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // list of latest locations
        //
        print(locations)
        locationLabel.text = "\(locations[0])"
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        print(error)
    }
    
    //
    // TODO make it ask again if location services was disabled
}

