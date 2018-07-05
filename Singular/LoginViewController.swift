//
//  LoginViewController.swift
//  Singular
//
//  Created by dlr4life on 7/4/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import Fabric

class LoginViewController: UIViewController, UINavigationControllerDelegate {
    
    var fbData = [String: AnyObject]()
    var twiData = [String: AnyObject]()
    var lnData = [String: AnyObject]()
    var gData = [String: AnyObject]()
    var iGDate = [String: AnyObject]()
    
    var image: String?
    var name: String?
    var email: String?
    
    let loadingView = UIActivityIndicatorView()
    let indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var EmailLoginBtn: UIButton!
    @IBOutlet weak var FacebookLoginBtn: UIButton!
    @IBOutlet weak var TwitterLoginBtn: UIButton!
    @IBOutlet weak var LinkedInLoginBtn: UIButton!
    @IBOutlet weak var GoogleLoginBtn: UIButton!
    @IBOutlet weak var IGLoginBtn: UIButton!
    
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
        loadingView.activityIndicatorViewStyle = .whiteLarge
        loadingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        loadingView.color = UIColor.black
        self.view.addSubview(loadingView)
        
        if IGLoginBtn.tag == 0 {
            
            self.performSegue(withIdentifier: "Login", sender: self)
        }
            
        else {
            
            IGLoginBtn.setTitle("Login", for: UIControlState())
            IGLoginBtn.setTitleColor(UIColor.blue, for: UIControlState())
            IGLoginBtn.tag = 0
            let storage = HTTPCookieStorage.shared
            for cookie in storage.cookies! {
                storage.deleteCookie(cookie)
            }
        }
    }
    
    /******************************************************/
    /****************** Google Delegates *******************/
    /******************************************************/
    
    //MARK: - WebView Delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        indicator.stopAnimating()
    }
}
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
