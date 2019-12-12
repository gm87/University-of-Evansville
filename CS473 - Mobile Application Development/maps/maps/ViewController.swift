//
//  ViewController.swift
//  maps
//
//  Created by Graham Matthews on 10/21/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var recording = false
    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var statsBackground: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var spdLabel: UILabel!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var distTitle: UILabel!
    @IBOutlet weak var spdTitle: UILabel!
    
    let locationManager: CLLocationManager = CLLocationManager()
    let timer = MyTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        map.delegate = self
        
        hideStats(boolean: true)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func hideStats(boolean: Bool) {
        statsBackground.isHidden = boolean
        TimeLabel.isHidden = boolean
        distLabel.isHidden = boolean
        spdLabel.isHidden = boolean
        timeTitle.isHidden = boolean
        distTitle.isHidden = boolean
        spdTitle.isHidden = boolean
    }
    
    var coords: [CLLocationCoordinate2D] = []
    var firstLoad = true
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if(recording) {
            coords.append(locValue)
            drawLine()
        }
        // set screen region
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        if(recording || firstLoad){
            self.map.setRegion(region, animated: true)
        }
        firstLoad = false
    }
    
    func drawLine() {
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        map.addOverlay(polyline)
    }
    
    @IBAction func startStopBtnAction(_ sender: Any) {
        recording = !recording
        if (recording) {
            hideStats(boolean: true)
            startStopBtn.setTitle("Stop", for: UIControl.State.normal)
            timer.startTimer()
        } else {
            var totalDist = 0.0
            if (coords.count >= 3) {
                for n in 0...coords.count-2 {
                    let loc1 = CLLocation(latitude: coords[n].latitude, longitude: coords[n].longitude)
                    let loc2 = CLLocation(latitude: coords[n+1].latitude, longitude: coords[n+1].longitude)
                    let distance = loc1.distance(from: loc2)
                    totalDist+=distance
                }
            }
            timer.stopTimer()
            print("counter")
            print(timer.getCounter())
            TimeLabel.text = String(format: "%.2f", timer.getCounter()) + "s"
            print("distance")
            print(totalDist)
            distLabel.text = String(format: "%.2f", totalDist) + "m"
            spdLabel.text = String(format: "%.2f", totalDist/timer.getCounter()) + "m/s"
            timer.resetCounter()
            startStopBtn.setTitle("Start", for: UIControl.State.normal)
            coords = []
            hideStats(boolean: false)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.fillColor = .blue
        renderer.lineWidth = 1.0
            
        return renderer
    }
}

