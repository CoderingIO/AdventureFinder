//
//  LoginViewController.swift
//  AdventureFinder
//
//  Created by Wayne Bangert on 3/23/16.
//  Copyright © 2016 Wayne Bangert. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let appName = "adventurefinder"
    
    let ref = Firebase(url: "https://adventurefinder.firebaseio.com/")
    let LoginToList = "LoginToList"
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //loginButton.enabled = false
        
        ref.observeAuthEventWithBlock { (authData) -> Void in
            
            if authData != nil {
                self.performSegueWithIdentifier(self.LoginToList, sender: nil)
            }
        }
    }
    
    @IBAction func loginTouched (sender:AnyObject) {
        
        
        self.ref.authUser(textFieldLoginEmail.text, password: textFieldLoginPassword.text, withCompletionBlock: { (error, auth) -> Void in
        })
    }

    @IBAction func signUpTouched(sender: AnyObject) {
        let alert = UIAlertController(title: appName, message: "Register", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
            
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            self.ref.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
                
                if error == nil {
                    self.ref.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) -> Void in
                    })
                }
            }
        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
