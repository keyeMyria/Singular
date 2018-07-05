//
//  FirstViewController.swift
//  Singular
//
//  Created by dlr4life on 8/9/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit
import LocalAuthentication

class FirstViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    var authError : NSError?
    var authContext = LAContext()

    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        nameTextField.delegate = self
//        nameTextField.becomeFirstResponder()
    }
    
    func TouchIDCall() {
        let context:LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:nil)
        {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason:"We Need Your Id", reply:{
                (wasSuccessful,Error) in
                if wasSuccessful
                {
                    UserDefaults.standard.set(self.nameTextField.text, forKey: "name")
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                    self.present(vc, animated: true, completion: nil)
                    print("Was a Sucess")
                }
                else
                {
                    print("Not Logged In")
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        toggleKeyboard()
        return false
    }
    
    func toggleKeyboard() {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        } else {
            nameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func continueTouched(_ sender: UIButton) {
        UserDefaults.standard.set(nameTextField.text, forKey: "name")
        nameTextField.resignFirstResponder()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func skipTouched(_ sender: AnyObject) {
        TouchIDCall()
    }
}
