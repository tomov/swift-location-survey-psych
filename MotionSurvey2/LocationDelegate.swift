//
//  LocationDelegate.swift
//  MotionSurvey2
//
//  Created by memsql on 2/6/16.
//  Copyright © 2016 Princeton. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDelegate: NSObject /*for @objc*/, CLLocationManagerDelegate {
    
    enum Mode: String {
        case OFF
        case UPDATING // startUpdatingLocation
        //case DEFERRED // allowDeferredBlaBla
        case MONITORING // startMonitoringSignificantChanges i.e. background mode
    }
    
    private var mode = Mode.OFF
    dynamic var modeString = ""
    
    private var locMgr = CLLocationManager()
    dynamic var location = CLLocation()
    
    private var geo = CLGeocoder()
    dynamic var address = ""
    
    static let sharedInstance = LocationDelegate()
    
    func setup () {
        locMgr.delegate = self
        locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        mode = Mode.OFF
        
        // request permission to use locations
        //
        locMgr.requestWhenInUseAuthorization() // for foreground
        locMgr.requestAlwaysAuthorization() // for background
        
        // we don't need this -- this is for e.g. hikes or Strava
        //locMgr.allowDeferredLocationUpdatesUntilTraveled(20.0, timeout: 5)  // meters, seconds (?)
        
        // TODO check? be more intelligent about it? check again when user comes back?
        //
        /* if (CLLocationManager.locationServicesEnabled()) {
        locMgr.startMonitoringSignificantLocationChanges();
        } else {
        print("Location services not enabled, please enable this in your Settings");
        }*/
    }

    // MARK: Some wrappers for our singleton
    
    func request() {
        // dosn't seem to work if startUpdatingLocation() or monitoring
        //
        locMgr.requestLocation()
    }
    
    func computeAddress() {
        geo.reverseGeocodeLocation(location) { (myPlacements, error) -> Void in
            if error != nil {
                self.address = "ERROR \(error)"
                print("\(error)")
            }
            
            if let myPlacemet = myPlacements?.first
            {
                self.address = "\(myPlacemet.locality!) \(myPlacemet.country!) \(myPlacemet.postalCode!)"
                print(self.address)
            }
        }
    }
    
    func startUpdating() {
        if mode == Mode.MONITORING {
            locMgr.stopMonitoringSignificantLocationChanges()
        }
        // foreground only -- receive updates every X meters
        //
        locMgr.distanceFilter = 20 // meters
        locMgr.startUpdatingLocation()
        mode = Mode.UPDATING
        modeString = mode.rawValue
    }
    
    func stopUpdating() {
        locMgr.stopUpdatingLocation()
        mode = Mode.OFF
        modeString = mode.rawValue
    }
    
    func startMonitoring() {
        if mode == Mode.UPDATING {
            locMgr.stopUpdatingLocation()
        }
        // background
        //
        locMgr.startMonitoringSignificantLocationChanges()
        mode = Mode.MONITORING
        modeString = mode.rawValue
    }
    
    func stopMonitoring() {
        locMgr.stopMonitoringSignificantLocationChanges()
        mode = Mode.OFF
        modeString = mode.rawValue
    }
    
    func postToRESTAPI() {
        let endpoint: String = "http://localhost:5000/add_data"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.HTTPMethod = "POST"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let data: NSDictionary = ["wtsafd": "asfddsf", "bla": "isaisaidf", "userId": 1]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: [])
            urlRequest.HTTPBody = jsonData
        } catch {
            print ("ERROR: cannot create JSON")
        }
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            print("GOT RESPONSE!!!")
            print("data = \(data)")
            print("response = \(response)")
            print("error = \(error)")
        })
        task.resume()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // list of latest locations
        //
        //dispatch_async(dispatch_get_main_queue()) {
        print(locations)
        location = locations[0]
       // self.locationLabel.text = "\(locations[0])" // setup KeyValueObserving thing in view controller
        //}
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