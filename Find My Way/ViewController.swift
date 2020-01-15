//
//  ViewController.swift
//  Find My Way
//
//  Created by MacStudent on 2020-01-14.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , CLLocationManagerDelegate {
    
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locatioManager = CLLocationManager()
    var places = [Place]()
    var tempTap = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        locatioManager.delegate = self
        mapView.showsUserLocation = true
        mapView.delegate = self
   
        locatioManager.desiredAccuracy = kCLLocationAccuracyBest
            locatioManager.requestWhenInUseAuthorization()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapping))
        tap.numberOfTapsRequired = 2
    
        
        mapView.addGestureRecognizer(tap)
        addPolyLine()
    }
    
    
    func addPolyLine(){
           let locations = places.map {$0.coordinate}
           let polyline = MKPolyline(coordinates: locations, count: locations.count)
           mapView.addOverlay(polyline)
       }

    
    
    @objc func tapping(gesture:UITapGestureRecognizer){
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        for overlay in mapView.overlays {
                   mapView.removeOverlay(overlay)
        }
        if (tempTap == 1) {
        let tap = gesture.location(in: mapView)
        let coordinate = mapView.convert(tap, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
       annotation.title = "Place to visit"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
           // tempTap = 1
            let destination = Place(coordinate: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
            places.append(destination)
            print(places[0].coordinate)
    }
}
    
    
    
    @IBAction func findButton(_ sender: UIButton) {
        // mapView.showsUserLocation = true
        getdirection(destination: places.last!.coordinate)
    }
    
    func getdirection(destination:CLLocationCoordinate2D){
        let destinationCoordinate = MKDirections.Request()
        
        let sourceCoodinate = mapView.userLocation.coordinate
        let source = CLLocationCoordinate2DMake(sourceCoodinate.latitude,sourceCoodinate.longitude)
        let destination = CLLocationCoordinate2DMake(destination.latitude, destination.longitude)
        
        print(source)
        print(destination)
        
        let Splacemark = MKPlacemark(coordinate: source)
        let Dplacemark = MKPlacemark(coordinate: destination)
        
        let finalsource = MKMapItem(placemark: Splacemark)
        let finaldestination = MKMapItem(placemark: Dplacemark)
        
        destinationCoordinate.source = finalsource
        destinationCoordinate.destination = finaldestination
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            destinationCoordinate.transportType = .walking
        case 1:
            destinationCoordinate.transportType = .automobile
        default:
            destinationCoordinate.transportType = .walking
        }
        
       // destinationCoordinate.transportType = .automobile
        
        let direction = MKDirections(request: destinationCoordinate)
        direction.calculate { (response , error) in
            
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                return
            }
            let route = response.routes[0]
            
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
        
    }
}



extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }else {
            
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
            pin.animatesDrop = true
            pin.tintColor = .red
            return pin
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    
        if overlay is MKPolyline {
         let rendrer = MKPolylineRenderer(overlay: overlay)
         rendrer.strokeColor = UIColor.blue
         rendrer.lineWidth = 5
         return rendrer
     }
        return MKOverlayRenderer()
}
}
