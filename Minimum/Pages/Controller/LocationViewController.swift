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
    private var userLocation: CLLocation?
    
    var navigation: [CLLocationCoordinate2D] = []
    
    var latPinPoint: Double = 0.0
    var longPinPoint: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Pilih Lokasi"
        
        manager.delegate = self
        userMapView.delegate = self
        
//        self.cancelButton.isEnabled = false
//        self.cancelButton.layer.opacity = 0.5
        
        customizeElement()
        
        setupMap()
        
        addPinPoint()
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = userMapView.userLocation.coordinate
        annotation.title = "Pick Up Location"
//        print("Pin Location, ", userMapView.userLocation.coordinate, ", ", userMapView.userLocation.coordinate)
        
        self.userMapView.addAnnotation(annotation)
        
    }
    
    //MARK: Map Setup
    //setting up the map
    func setupMap() {
        
        //Set delegate to view controller
        userMapView.delegate = self
        
        //map view showing user location
        userMapView.showsUserLocation = true
        
        //user location default value used
//        userLocation = CLLocation(latitude: -6.310177, longitude: 106.652992)
        
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
    }
    
    //MARK: Location Manager when Updated
    //function run when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //getting location of current position and passing the data to userLocation variable
        if let location = locations.last{
            self.userLocation = location
        }
        
        self.manager.stopUpdatingLocation()
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let centerLocation = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let regions = MKCoordinateRegion(center: centerLocation, latitudinalMeters: 250.0, longitudinalMeters: 250.0)
        
        //bring camera to this position
        self.userMapView.setRegion(regions, animated: true)
    }
    
    func center(onRoute route: [CLLocationCoordinate2D], fromDistance km: Double) {
        let center = MKPolyline(coordinates: route, count: route.count).coordinate
        userMapView.setCamera(MKMapCamera(lookingAtCenter: center, fromDistance: km * 1000, pitch: 0, heading: 0), animated: false)
    }
    
    //MARK: Function run if there's an error in the Location Manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //print the error description
        print(error.localizedDescription)
    }
    
    @IBAction func getThisLocation(_ sender: Any) {
        //getting the coordinate of user location
//        if getCurrentLocationOutlet.titleLabel?.text == "Gunakan Lokasi"{
        
//                    if let coordinate = userLocation?.coordinate {
//
//                        //When user click the button, the current location shown with latitudinal and longitudinal meters of 1000
//                        let coordinateRegion = MKCoordinateRegion(center: coordinate,
//                                                                  latitudinalMeters: CLLocationDistance(1000), longitudinalMeters: CLLocationDistance(1000))
//
//                        //setting the region view of 1000 radius
//                        userMapView.setRegion(coordinateRegion, animated: true)
//
//                        latPinPoint = userLocation?.coordinate.latitude ?? 0.0
//                        longPinPoint = userLocation?.coordinate.longitude ?? 0.0
        
//                        fetchCityAndCountry(from: userLocation!) { subStreet, street, city, country, error in
//                            guard let subStreet = subStreet, let street = street, let city = city, let country = country, error == nil else { return }
//                            print(subStreet + ", " + street + ", " + city + ", " + country)
//
//                            self.locationPickedLabel.text = subStreet + ", " + street + ", " + city + ", " + country
//
//                        }
            
//                        DispatchQueue.main.async {
//                            self.getCurrentLocationOutlet.setTitle("Konfirmasi", for: .normal)
            
//                            self.cancelButton.isEnabled = true
//                            self.cancelButton.layer.opacity = 1
//                        }
                        
//                    }
            
//        }else{
            let alert = UIAlertController(title: "Konfirmasi", message: "Apakah point yang anda taruh sudah pas?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ya", style: .default) { (_) in
                    print("success")
                    print(self.latPinPoint)
                    print(self.longPinPoint)
                
                    self.performSegue(withIdentifier: "unwindToOrder", sender: self)
                }
            
            
            let cancelAction = UIAlertAction(title: "Batal", style: .cancel){ (_) in
                self.getCurrentLocationOutlet.setTitle("Gunakan Lokasi Saat Ini", for: .normal)
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
//        }
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
        
//        self.cancelButton.isEnabled = true
//        self.cancelButton.layer.opacity = 1
        
//        fetchCityAndCountry(from: pinLocation) { subStreet, street, city, country, error in
//            guard let subStreet = subStreet, let street = street, let city = city, let country = country, error == nil else {
//                print("error, ", error)
//                return }
//            print("Location Pin : ", subStreet + ", " + street + ", " + city + ", " + country)
//
//            self.locationPickedLabel.text = subStreet + ", " + street + ", " + city + ", " + country
        
        self.locationPickedLabel.text = "Pick Up Location in \n\(latPinPoint), \(longPinPoint)"

//
//        }
        
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
            
            //            setUpPickUpPointer()
            
        } else {
            print("PLease turn on location services or GPS")
        }
    }
    
    
//    @IBAction func remove(_ sender: Any) {
//        removeMarker()
//        self.getCurrentLocationOutlet.setTitle("Gunakan Lokasi Saat Ini", for: .normal)
//    }

    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ subStreet: String?, _ street: String?, _ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.subThoroughfare,
                       placemarks?.first?.thoroughfare,
                       placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }

    func customizeElement(){
        getCurrentLocationOutlet.layer.cornerRadius = 11
        informationView.layer.cornerRadius = 11
        informationView.layer.shadowColor = UIColor.lightGray.cgColor
        informationView.layer.shadowOpacity = 1
        informationView.layer.shadowOffset = CGSize(width: 0, height: -2)
        informationView.layer.shadowRadius = 10
        
//        cancelButton.layer.cornerRadius = 11

    }
}
