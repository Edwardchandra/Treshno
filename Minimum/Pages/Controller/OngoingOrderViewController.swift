//
//  OngoingOrderViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 26/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class OngoingOrderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var userMapView: MKMapView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var wasteCollectorImageView: UIImageView!
    @IBOutlet weak var wasteCollectorName: UILabel!
    @IBOutlet weak var wasteCollectorNumber: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var fotoSampah: UIImageView!
    
    //MARK: Variables
    //variables to be used
    private var userDestination: MKMapItem?
    private var locationManager: CLLocationManager = CLLocationManager()
    private var userLocation: CLLocation?
    
    private var coordinateLatitude: [Double] = []
    private var coordinateLongitude: [Double] = []
    private var steps: Int = 0
    
    var navigation: [CLLocationCoordinate2D] = []
    
    var pointAnnotation : CustomAnnotation!
    var pinAnnotationView : MKAnnotationView?
    
    var currentStep = 0
    
    //Set Destination
    var latPinPoint: Double = 0.0
    var longPinPoint: Double = 0.0
    
    var latCurrent : Double = 0.0
    var longCurrent : Double = 0.0
    
    var sourceLocationData: String = ""
    var destinationLocationData: String = ""
    
    var image: UIImage = UIImage(named: "Launch")!
    
    var sourceLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
    
    var eta: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Pesanan Anda Saat Ini"
        self.navigationItem.setHidesBackButton(true, animated:true)
        
//        fotoSampah.image = image
        wasteCollectorImageView.image = UIImage(named: "wasteCollector")
        
//        customizeElement()
        
        setupMap()
        
        navigate()
    }
    
    //MARK: Map Setup
    //setting up the map
    func setupMap() {
        
        //Set delegate to view controller
        userMapView.delegate = self
        
        //map view showing user location
        userMapView.showsUserLocation = true
        
        //user location default value used
//        userLocation = CLLocation(latitude: -6.301492, longitude: 106.652992)
        
        //accuracy of the location set to best,
        //developer can set it to 3 metres, 10 metres, etc of accuracy.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //set location manager delegate to view controller
        locationManager.delegate = self
        
        //check the authorization status by the user
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//
//            //start updating the location of the current position
//            locationManager.startUpdatingLocation()
//        } else {
//
//            //request permission to the user when is going to use it in the foreground
//            locationManager.requestWhenInUseAuthorization()
//        }
    }
    
    func navigate(){
        sourceLocation = CLLocationCoordinate2D(latitude: -6.309411, longitude: 106.647424) // Depan Unilever
        destinationLocation = CLLocationCoordinate2D(latitude: latPinPoint, longitude: longPinPoint)
        print("Destination: \n latitude ", latPinPoint, "\n longitude ", longPinPoint)
        
        //MARK: - Pin Destination
        let pointDestination = MKPointAnnotation()
        pointDestination.coordinate = CLLocationCoordinate2D(
            latitude: destinationLocation!.latitude,
            longitude: destinationLocation!.longitude)
        
        let pinViewDestination = MKAnnotationView(annotation: pointDestination, reuseIdentifier: "destinationPin")
        
        userMapView.addAnnotation(pinViewDestination.annotation!)
        
        //MARK: - Set Camera Location
        let centerLocation = CLLocationCoordinate2D(latitude: destinationLocation!.latitude, longitude: destinationLocation!.longitude)
        let regions = MKCoordinateRegion(center: centerLocation, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        
        self.userMapView.setRegion(regions, animated: true)
        
        //MARK: - Create Route
        createRoute(withSource: sourceLocation!,
                    andDestination: CLLocationCoordinate2D(
                        latitude: destinationLocation!.latitude,
                        longitude: destinationLocation!.longitude))
        
        
        
    }
    
    //MARK: Function to Overlay the Road
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        pointAnnotation = CustomAnnotation()
        pointAnnotation.pinCustomImageName = "truck"
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latCurrent, longitude: longCurrent)
        pinAnnotationView = MKAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")

        userMapView.addAnnotation(pinAnnotationView!.annotation!)

        move(arrayOfSteps: navigation)
        
        return renderer
    }
    
    //MARK: - Create Route
    func createRoute(withSource source: CLLocationCoordinate2D, andDestination destination: CLLocationCoordinate2D){
        
        let sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
//        userMapView.removeOverlays(userMapView.overlays)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            for route in response.routes{
                self.eta = route.expectedTravelTime
                
                DispatchQueue.main.async {
                    self.estimatedTime.text = self.stringFromTimeInterval(interval: self.eta!) as String
                }
                
            }
            
            self.navigation.removeAll()
            let route = response.routes[0]//tujuan
            let totalStep = response.routes[0].steps
            
            for i in 0 ..< totalStep.count{
                print("Responses : \(response.routes[0].steps[i].polyline.coordinate)")
                self.navigation.append(response.routes[0].steps[i].polyline.coordinate)
            }
            
            self.userMapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            print("Cek Polyline: ", route.polyline.coordinate)
            
            
            let rect = route.polyline.boundingMapRect
            self.userMapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
//        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
//
//        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "Akan tiba dalam %d jam %d menit",hours,minutes)
    }
    
    //MARK:- Function Animate
    func  moveCar(_ arrayOfSteps : [CLLocationCoordinate2D]) {
        move(arrayOfSteps: arrayOfSteps)
        
    }
    
    func move(arrayOfSteps : [CLLocationCoordinate2D]){
        var timer = 0
        switch currentStep{
        case 0:
            timer = 1
        default:
            timer = 5
        }
        
        if self.currentStep < arrayOfSteps.count{
            UIView.animate(withDuration: TimeInterval(timer), animations: {
                self.pointAnnotation.coordinate = arrayOfSteps[self.currentStep]
            }, completion:  { success in
                
                // handle a successfully ended animation
                if self.currentStep < arrayOfSteps.count - 1{
                    self.currentStep += 1
                    self.move(arrayOfSteps: arrayOfSteps)
                }else{
                    print("Hei, Your Picker already Arrive!")
                    
                    self.finishButton.isEnabled = true
                    self.finishButton.layer.opacity = 1
                }
            })
        }else{
            print("Hei, Your Picker already Arrive!")
            self.performSegue(withIdentifier: "selesaiCuy", sender: self)
        }
    }
    
    @IBAction func finishAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Konfirmasi", message: "Apakah anda ingin menyelesaikan pesanan anda?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.performSegue(withIdentifier: "orderReviewSegue", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
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
        finishButton.layer.cornerRadius = 11
        cardView.layer.cornerRadius = 11
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: -2)
        cardView.layer.shadowRadius = 10

        finishButton.isEnabled = false
        finishButton.layer.opacity = 0.5
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "orderReviewSegue"{
            
            let destination = segue.destination as! OrderReviewViewController
            destination.source = sourceLocationData
            destination.destination = destinationLocationData
            destination.wasteImage = image
            destination.wasteCollector = wasteCollectorName.text!
        }
        
    }
    
    
}
