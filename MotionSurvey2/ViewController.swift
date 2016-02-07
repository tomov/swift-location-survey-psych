//
//  ViewController.swift
//  MotionSurvey2
//
//  Created by memsql on 2/3/16.
//  Copyright © 2016 Princeton. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    private var kvoLocationChangedContext: UInt8 = 1
    private var kvoLocationModeChangedContext: UInt8 = 1
    private var kvoAddressChangedContext: UInt8 = 1
    
    private var geo = CLGeocoder()
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var geoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Key-Value-Observing (KVO) for location changes and such
        // Welcome back to Objective-C land
        //
        LocationDelegate.sharedInstance.addObserver(self, forKeyPath: "location", options: NSKeyValueObservingOptions.New, context: &kvoLocationChangedContext)
        LocationDelegate.sharedInstance.addObserver(self, forKeyPath: "modeString", options: NSKeyValueObservingOptions.New, context: &kvoLocationModeChangedContext)
        LocationDelegate.sharedInstance.addObserver(self, forKeyPath: "address", options: NSKeyValueObservingOptions.New, context: &kvoAddressChangedContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &kvoLocationChangedContext {
            locationLabel.text = "\(LocationDelegate.sharedInstance.location)"
        }
        if context == &kvoLocationModeChangedContext {
            actionLabel.text = LocationDelegate.sharedInstance.modeString
        }
        if context == &kvoAddressChangedContext {
            geoLabel.text = LocationDelegate.sharedInstance.address
        }
    }
    
    @IBAction func postToRest(sender: AnyObject) {
        LocationDelegate.sharedInstance.postToRESTAPI(["asdfasdf": "3123sdf", "sdfs": 1, "sdfsdf": "wtf"])
    }
    
    @IBAction func reverseGeoCode(sender: AnyObject) {
        LocationDelegate.sharedInstance.computeAddress()
    }
    
    @IBAction func startUpdatingLocation(sender: AnyObject) {
        LocationDelegate.sharedInstance.startUpdating()
    }
    
    @IBAction func StopUpdatingLocation(sender: AnyObject) {
        LocationDelegate.sharedInstance.stopUpdating()
    }
    
    @IBAction func startMonitoringSignificantChanges(sender: AnyObject) {
        LocationDelegate.sharedInstance.startMonitoring()
    }
    
    @IBAction func stopMonitoringSignificantChanges(sender: AnyObject) {
        LocationDelegate.sharedInstance.stopMonitoring()
    }
    
    @IBAction func getFixPressed(sender: AnyObject) {
        LocationDelegate.sharedInstance.request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

