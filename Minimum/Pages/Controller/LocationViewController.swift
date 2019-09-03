//
//  LocationViewController.swift
//  Minimum
//
//  Created by Jessica Jacob on 22/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var userMapView: MKMapView!
    
    let manager = CLLocationManager()
    @IBOutlet weak var getCurrentLocationOutlet: UIButton!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var locationPickedLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var getLocationNow: UIButton!
    
    //MARK: Variables
    //variables to be used
    private var userDestination: MKMapItem?
    private var locationManager: CLLocationManager = CLLocationManager()
    private var userLocation: CLLocation = CLLocation()
    
    var navigation: [CLLocationCoordinate2D] = []
    
    var latPinPoint: Double = 0.0
    var longPinPoint: Double = 0.0
    
    var locationDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pilih Lokasi Jemput"

        customizeElement()
        
        manager.delegate = self
        userMapView.delegate = self
        
//        manager.is
        
        setupMap()
        
        addPinPoint()
        
        
    }
    
    //MARK: Map Setup
    //setting up the map
    func setupMap() {
        
        //Set delegate to view controller
        userMapView.delegate = self
        
        //map view showing user location
        userMapView.showsUserLocation = true
        
        //accuracy of the location set to best,
        //developer can set it to 3 metres, 10 metres, etc of accuracy.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //set location manager delegate to view controller
        locationManager.delegate = self
        
        //check the authorization status by the user
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            //start updating the location of the current position
            locationManager.startUpdatingLocation()
        } else {
            
            //request permission to the user when is going to use it in the foreground
            locationManager.requestWhenInUseAuthorization()
        }
        
        print("UserLocLat, ", userMapView.userLocation.coordinate.latitude)
        print("UserLocLong, ", userMapView.userLocation.coordinate.longitude)
        
    }
    
    @IBAction func getThisLocation(_ sender: Any) {
       
        let alert = UIAlertController(title: "Konfirmasi", message: "Apakah titik jemput sudah sesuai?", preferredStyle: .alert)
            
        
        let cancelAction = UIAlertAction(title: "Belum", style: .cancel){ (_) in
            self.getCurrentLocationOutlet.setTitle("Gunakan Lokasi Saat Ini", for: .normal)
        }
        
        let okAction = UIAlertAction(title: "Sudah", style: .default) { (_) in
            print("success")
                
            self.performSegue(withIdentifier: "unwindToOrder", sender: self)
        }
            
        alert.addAction(okAction)
        alert.addAction(cancelAction)
            
        self.present(alert, animated: true, completion: nil)
    }
    
    func addPinPoint(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.addPinPointGesture))
        userMapView.addGestureRecognizer(gesture)
    }
    
    @objc func addPinPointGesture(gestureReconizer: UILongPressGestureRecognizer){
        
        userMapView.removeAnnotations(userMapView.annotations)

        let location = gestureReconizer.location(in: userMapView)
        let coordinate = userMapView.convert(location, toCoordinateFrom: userMapView)
        
        latPinPoint = coordinate.latitude
        longPinPoint = coordinate.longitude
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        annotation.title = "Pick Up Location"
        print("Pin Location, ", coordinate.latitude, ", ", coordinate.longitude)

        self.userMapView.addAnnotation(annotation)
        
        latPinPoint = coordinate.latitude
        longPinPoint = coordinate.longitude
        
        getNameLocation(coordinate: annotation.coordinate)

//        locationPickedLabel.text = getNameLocation(coordinate: annotation.coordinate)

    }
    
    @IBAction func getMyLocationAction(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined {
                
                //3.4. Call the auth here
                manager.requestAlwaysAuthorization()
                manager.requestWhenInUseAuthorization()
            }
            
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.distanceFilter = 20
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            manager.startUpdatingLocation()
        } else {
            print("PLease turn on location services or GPS")
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    //MARK: Location Manager when Updated
    //function run when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userMapView.removeAnnotations(userMapView.annotations)
        manager.distanceFilter = 100
        
        //getting location of current position and passing the data to userLocation variable
        if let location = locations.last{
            self.userLocation = location
        }
        
        //Add Pin when first Launch
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        annotation.title = "Pick Up Location"
        self.userMapView.addAnnotation(annotation)
        
         getNameLocation(coordinate: annotation.coordinate)
        
        //Get Name for Places
        
        //Set Value of Coordinate
        latPinPoint = annotation.coordinate.latitude
        longPinPoint = annotation.coordinate.longitude
        
        //Stop Update Location
        self.manager.stopUpdatingLocation()
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let centerLocation = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let regions = MKCoordinateRegion(center: centerLocation, latitudinalMeters: 250.0, longitudinalMeters: 250.0)
        
        //bring camera to this position
        self.userMapView.setRegion(regions, animated: true)
    }
    
    
    //MARK: Function run if there's an error in the Location Manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //print the error description
        print(error.localizedDescription)
    }
    
    func customizeElement(){
        getCurrentLocationOutlet.layer.cornerRadius = 11
    }
    
    func getNameLocation(coordinate: CLLocationCoordinate2D){
        var city = ""
        var nameLoc = ""
        var locationLoc = ""
        var countryLoc = ""
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                if let name = placeMark.name{
                    print("name ", name)
                    nameLoc = name
                }
                
                // Location name
                if let locationName = placeMark.subLocality {
                    print("locName ", locationName)
                    locationLoc = locationName
                }
 
                // Country
                if let country = placeMark.country {
                    print("Country ", country)
                    countryLoc = country
                    
                }
                city = "\(nameLoc), \(locationLoc), \(countryLoc)"
                print("City: ", city)
                
                self.locationPickedLabel.text = city
                self.locationDetail = city
        })
    }
}
