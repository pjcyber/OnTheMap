//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/9/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit
import MapKit
import FacebookLogin

class MapViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    // loading students data
    override func updateView(students: [StudentInformation], error: Error?) {
        if error == nil {
            save(students: students)
            var annotations = [MKPointAnnotation]()
            
            for student in getStudents() {
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(student.latitude),
                                                        longitude: CLLocationDegrees(student.longitude))
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(student.firstName) \(student.lastName)"
                annotation.subtitle = student.mediaURL
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
        } else {
            self.showErrorAlert(title: "Load locations faild", message: error?.localizedDescription ?? "")
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let toOpen = view.annotation?.subtitle! else {
                return
            }
            guard let url = URL(string: toOpen) else {
                self.showErrorAlert(title: "Error", message: "no url")
                return
            }
            UIApplication.shared.open(url)
        }
    }
}
