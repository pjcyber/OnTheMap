//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/8/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit
import Foundation
import FacebookLogin

class LoginViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var signUpTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = ""
        passwordTextField.text = ""
        createSignUpSpannable()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func loginOnClick(_ sender: Any) {
        if Reachability().isConnectedToNetwork() {
            setLoggingIn(true)
            let udacity: Udacity = Udacity(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")
            UdacityClient.login(udacity: udacity, completion: handleLoginResponse(success:error:))
        } else {
            showErrorAlert(title: "Internet Conection", message: "please verify your internet connection")
        }
    }
    
    @IBAction func facebookLoginOnClick(_ sender: Any) {
        if Reachability().isConnectedToNetwork() {
            setLoggingIn(true)
            UdacityClient.loginWithFacebook { (success, error) in
                if success {
                    self.setLoggingIn(false)
                    self.performSegue(withIdentifier: "loginSuccessful", sender: self)
                }
                
                if error != nil {
                    self.showErrorAlert(title: "Login Failed", message: "Error in Facebook Login")
                }
            }
        } else {
            showErrorAlert(title: "Internet Conection", message: "please verify your internet connection")
        }
    }
    
    // enable/disable Textfield and buttons
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        facebookLoginButton.isEnabled = !loggingIn
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "loginSuccessful", sender: self)
        } else {
            showErrorAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    // signUp spannable
    func createSignUpSpannable() {
        let text = NSMutableAttributedString(string: "Don't have account? ")
        text.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                            NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 0, length: text.length))
        
        let selectablePart = NSMutableAttributedString(string: "Sign Up!")
        selectablePart.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                      NSAttributedString.Key.foregroundColor: UIColor.blue],
                                     range: NSRange(location: 0, length: selectablePart.length))
        
        // Add an NSLinkAttributeName with a value of an url or anything else
        selectablePart.addAttribute( NSAttributedString.Key.link, value: NSURL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")!, range: NSRange(location: 0, length: selectablePart.length))
        
        // Combine the non-selectable string with the selectable string
        text.append(selectablePart)
        
        // Center the text (optional)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.length))
        
        // To set the link text color (optional)
        signUpTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue,
                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        // Set the text view to contain the attributed text
        signUpTextView.attributedText = text
        // Disable editing, but enable selectable so that the link can be selected
        signUpTextView.isEditable = false
        signUpTextView.isSelectable = true
        signUpTextView.isScrollEnabled = false
        // Set the delegate in order to use textView(_:shouldInteractWithURL:inRange)
        signUpTextView.delegate = self
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    // to hide keyboard after press enter
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
