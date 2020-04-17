//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/10/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit

extension UIViewController: RefreshDelegate {
    
    // MARK: - IBAction
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityClient.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        clearCache()
        refreshView()
    }
    
    // functions bewteen UIViewControllwer
    
    // this delegate should be implement by the View Controller that request data
    @objc func refreshView() {
        if getStudents().isEmpty {
            UdacityClient.getLocations { students, error in self.updateView(students: students, error: error)}
        } else {
            updateView(students: getStudents(), error: nil)
        }
    }
    
    // this delegate load student data
    @objc func updateView(students: [StudentInformation], error: Error?) {
        //no-op
    }
    
    // share functions for session
    @objc func checkSeesion() {
        if UdacityClient.isTokenExpired() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func save(students: [StudentInformation]) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.students = []
        appDelegate.students = students
    }
    
    @objc func getStudents() -> [StudentInformation] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.students
    }
    
    @objc func clearCache() {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.students = []
    }
    
    // function to to show error alert
    @objc func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //show(alert, sender: self)
        self.present(alert, animated: true, completion: nil)
    }
}
