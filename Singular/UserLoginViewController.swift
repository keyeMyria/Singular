//
//  UserLoginViewController.swift
//  Singular
//
//  Created by dlr4life on 7/4/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController, UINavigationControllerDelegate {
    
    var emailData = [String: AnyObject]()

    var name: String?
    var email: String?
    
    let loadingView = UIActivityIndicatorView()
    let indicator = UIActivityIndicatorView()

    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var showProfileBtn: UIButton!
    @IBOutlet var forgottenCredential: UIButton!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if (!isUserLoggedIn)
        {
            //            self.performSegue(withIdentifier: "menuView", sender: self)
            //            let vc = MainViewController() //change this to your class name
            //            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        super.viewDidLoad()
    }
    
    @IBAction func logInButton(_ sender: Any) {
        let userEmail = userEmailTextField
        let userPassword = userPasswordTextField
        
        let userEmailStord = UserDefaults.standard.string(forKey: "userEmail")
        let userPasswordStord = UserDefaults.standard.string(forKey: "userPassword")
        let userNameStored = UserDefaults.standard.string(forKey: "username")
        
        if (userEmail?.text == userEmailStord || userEmail?.text == userNameStored)
        {
            if (userPassword?.text == userPasswordStord)
            {
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true, completion: nil)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let _ = storyboard.instantiateViewController(withIdentifier: "MenuNavVC")
            
        }
        else {
            let alertMessage = UIAlertController(title: "Login Problem", message: "Email/Username or Password incorrect. Try again", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertMessage.addAction(okAction)
            
            self.present(alertMessage, animated: true, completion: nil)
            return
        }
    }
    
    
    @IBAction func forgottenCredentialPressed(_ sender: Any) {
        forgottenCredential.setTitleColor(UIColor.green, for: UIControlState())
        
    }
    
    @IBAction func showProfile(_ sender: Any) {
        showProfileBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }
}
