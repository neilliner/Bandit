//
//  LocationCell.swift
//  Bandit
//
//  Created by Piyoros Vephula on 2/8/16.
//  Copyright © 2016 Piyoros Vephula. All rights reserved.
//

import UIKit
import ParseUI
import MapKit
//import CoreLocation

class LocationCell: PFTableViewCell, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    var addressString = ""
    
    let locationManager = CLLocationManager()
    var latLong = [Float]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        address.text = "Address"
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        //print(location)
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
        //let center = CLLocationCoordinate2DMake(CLLocationDegrees(latLong[0]), CLLocationDegrees(latLong[1]))
        
        
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            let placeArray = placemarks as! [CLPlacemark]!
            
            var placeMark: CLPlacemark!
            placeMark = placeArray[0]
            
            print(placeMark)
            //print(placeMark.addressDictionary)
            //print(placeMark.name)
            //print(placeMark.subAdministrativeArea)
            //self.street.text = placeMark.name!
            //self.city.text = placeMark.subAdministrativeArea!
            
            //self.addressString = "\(placeMark.name) \(placeMark.administrativeArea)"
            self.address.text = "\(placeMark.name!) \(placeMark.administrativeArea!)"
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

}
