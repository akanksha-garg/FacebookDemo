//
//  ViewController.swift
//  FacebookDemo
//
//  Created by Akanksha on 02/06/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD

class ViewController: UIViewController {
    
    let permissions = ["public_profile", "email", "user_about_me", "user_location","user_friends", "friends_photos"]
    let userFields = "id, cover, name, picture.type(small), email, friends"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLoginButtonPressed(_ sender: Any) {
        facebookLoginSignUp()
    }
    
    func facebookLoginSignUp() {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        loginManager.logIn(withReadPermissions:permissions, from: self) { (result: FBSDKLoginManagerLoginResult?,error: Error?) in
            if error != nil {
                
                self.showAlertViewWithMessage(message: "\(error?.localizedDescription ?? "Facebook Login Again.")")
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            else if error == nil
            {
                self.userInfo({ (response: AnyObject?,error: NSError?) in
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    if error == nil
                    {
                        let dict = response as! Dictionary<String, Any>
                        //Navigate to UserDetails and display fetched information.
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let userDetailtVC = storyBoard.instantiateViewController(withIdentifier: "UserDetailsVC") as! UserDetailsViewController
                        userDetailtVC.resultDataDictionary = dict
                        self.navigationController?.pushViewController(userDetailtVC, animated: true)
                    }
                    else {
                        self.showAlertViewWithMessage(message: "\(error?.localizedDescription ?? "Unable to fetch data.")")
                    }
                })
            }
        }
    }
    
    func userInfo(_ completion:((_ response: AnyObject?, _ error: NSError?) -> Void)?) {
        // got login....
        let param = NSMutableDictionary()
        param.setObject(userFields, forKey: "fields" as NSCopying)
        let userData = param as NSDictionary? as? [AnyHashable: Any] ?? [:]
        let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: userData as [AnyHashable: Any])
        let _ = fbRequest?.start(completionHandler: { (connection, result, error) in
            if let block = completion {
                block(result as AnyObject?,error as NSError?)
            }
        })
    }
    
    //To Show Alert Message in case of error
    func showAlertViewWithMessage(_ title: String = "Error!", message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
