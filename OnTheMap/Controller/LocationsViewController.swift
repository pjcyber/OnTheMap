//
//  LocationsViewController.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/9/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        refreshView()
        tableView.reloadData()
    }
    
    // loading students data
    override func updateView(students: [StudentInformation], error: Error?) {
        if error == nil {
            save(students: students)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        } else {
            self.showErrorAlert(title: "Load locations faild", message: error?.localizedDescription ?? "")
        }
    }
}

extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getStudents().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = getStudents()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        cell.setLocation(location: location)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let students = self.getStudents()
        let toOpen = students[indexPath.row].mediaURL
        guard let url = URL(string: toOpen) else {
            self.showErrorAlert(title: "Error", message: "no url")
            return
        }
        UIApplication.shared.open(url)
    }
}
