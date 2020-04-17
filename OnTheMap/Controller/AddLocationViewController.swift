//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/10/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    // MARK: - Global variables
    var locationRequest: LocationRequest!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSeesion()
    }
    
    // MARK: - IBAction
    @IBAction func findOnClick(_ sender: Any) {
        if let addressString = locationTextField.text, let mediaURL = linkTextField.text {
            getCoordinate(addressString: addressString) { (location, error) in
                if error == nil {
                    var url: URL?
                    if !mediaURL.isEmpty {
                        url = URL(string: mediaURL)
                    }
                    self.locationRequest = LocationRequest(latitude: location.latitude, longitude: location.longitude,
                                                           mapString: addressString, mediaURL: url)
                    self.performSegue(withIdentifier: "GoToPinLocation", sender: nil)
                } else {
                    self.showErrorAlert(title: "Error", message: error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PinLocationViewController {
            let vc = segue.destination as? PinLocationViewController
            vc?.locationRequest = locationRequest
        }
    }
    
    @IBAction func cancelOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}

extension AddLocationViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    // to hide keyboard after press enter
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
