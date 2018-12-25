//
//  ViewController.swift
//  AppleStores-GeoFencing
//
//  Created by Sudeepta Das on 12/24/18.
//  Copyright © 2018 Sudeepta Das. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let places = Place.getPlaces()
    
    @IBAction func changeRadius(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let overlays = mapView?.overlays
            mapView?.removeOverlays(overlays!)
            if let userLocation = locationManager.location?.coordinate{
                let overlays = MKCircle(center: CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude), radius: 8046.72)
                mapView!.addOverlay(overlays)
            }
        case 1:
            let overlays = mapView?.overlays
            mapView?.removeOverlays(overlays!)
            if let userLocation = locationManager.location?.coordinate{
                let overlays = MKCircle(center: CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude), radius: 16093.4)
                mapView!.addOverlay(overlays)
            }
        case 2:
            let overlays = mapView?.overlays
            mapView?.removeOverlays(overlays!)
            if let userLocation = locationManager.location?.coordinate{
                let overlays = MKCircle(center: CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude), radius: 24140.2)
                mapView!.addOverlay(overlays)
            }
        default:
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation=true
        mapView.delegate=self
        
        // Do any additional setup after loading the view, typically from a nib.
        requestLocationAccess()
        addAnnotations()
        let regionRadius: Double = 100000
        if let userLocation = locationManager.location?.coordinate{
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView?.setRegion(viewRegion, animated: false)
        }
        if let userLocation = locationManager.location?.coordinate{
            let overlays = MKCircle(center: CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude), radius: 8046.72)
            mapView!.addOverlay(overlays)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let locValue:CLLocationCoordinate2D = userLocation.coordinate;
        print(locValue.latitude)
        print(locValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(region.identifier)
    }
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func addAnnotations() {
        mapView?.delegate = self
        mapView?.addAnnotations(places)
    }



    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }else{
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
            pinView.pinTintColor = UIColor.blue
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView.canShowCallout = true
            annotationView = pinView
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.lightGray
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place, let title = annotation.title else { return }
        
        let alertController = UIAlertController(title: "You have selected \(title)", message: "You are at \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}


