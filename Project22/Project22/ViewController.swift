//
//  ViewController.swift
//  Project22
//
//  Created by Glenn R. Fisher on 8/14/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var distanceReading: UILabel!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(
            proximityUUID: uuid,
            major: 123,
            minor: 456,
            identifier: "myBeacon"
        )
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus)
    {
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) else { return }
        guard CLLocationManager.isRangingAvailable() else { return }
        startScanning()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        in region: CLBeaconRegion)
    {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}
