//
//  OptionViewController.swift
//  Singular
//
//  Created by dlr4life on 7/4/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import Fabric

class OptionViewController: UIViewController {

    var fbData = [String: AnyObject]()
    var twiData = [String: AnyObject]()
    var lnData = [String: AnyObject]()
    var gData = [String: AnyObject]()
    var iGDate = [String: AnyObject]()
    
    var image: String?
    var name: String?
    var email: String?
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var birthYearTextField: UITextField!
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var EmailLoginBtn: UIButton!
    @IBOutlet weak var FacebookLoginBtn: UIButton!
    @IBOutlet weak var TwitterLoginBtn: UIButton!
    @IBOutlet weak var LinkedInLoginBtn: UIButton!
    @IBOutlet weak var GoogleLoginBtn: UIButton!
    @IBOutlet weak var IGLoginBtn: UIButton!

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 8

        signUpBtn.layer.cornerRadius = 8

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        super.viewDidLoad()
    }

    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        signUpBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        EmailLoginBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }
    
    @IBAction func loginWithLn(_ sender: Any) {
        LinkedInLoginBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }
    
    @IBAction func loginWithTwitter(_ sender: Any) {
        TwitterLoginBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }
    
    @IBAction func loginWithFb(_ sender: Any) {
        FacebookLoginBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GoogleLoginBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }
    
    @IBAction func loginWithInstagram(_ sender: Any) {
        IGLoginBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        loginBtn.setTitleColor(UIColor.green, for: UIControlState())
        
    }


}

