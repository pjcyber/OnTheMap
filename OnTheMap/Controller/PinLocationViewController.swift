//
//  PinLocationViewController.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/10/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit
import MapKit

class PinLocationViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var pinMapView: MKMapView!
    
    // MARK: - Global variables
    var locationRequest: LocationRequest?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let locationRequest = locationRequest {
            let latitud = locationRequest.latitude
            let longitude = locationRequest.longitude
            
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitud), longitude: CLLocationDegrees(longitude))
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(locationRequest.firstName) \(locationRequest.lastName)"
            if let url = locationRequest.mediaURL {
                annotation.subtitle = url.absoluteString
            }
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            pinMapView.setRegion(region, animated: true)
            pinMapView.addAnnotation(annotation)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSeesion()
    }
    
    // MARK: - IBAction
    @IBAction func addLocation(_ sender: Any) {
        if let locationRequest = locationRequest {
            UdacityClient.addStudentLocation(locationRequest: locationRequest) { _, error in
            if error != nil {
                    self.clearCache()
                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {

                    self.showErrorAlert(title: "Add Location Failed", message: error?.localizedDescription ?? "")
                }
            }
        }
    }
}

extension PinLocationViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
