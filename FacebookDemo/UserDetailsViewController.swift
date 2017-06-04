//
//  UserDetailsViewController.swift
//  FacebookDemo
//
//  Created by Akanksha on 02/06/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage
import MBProgressHUD
import FBSDKCoreKit

class UserDetailsViewController: UIViewController {
    
    var resultDataDictionary: Dictionary<String, Any> = [:]
    var friendsList : [[String:AnyObject]] =  []
    let friendFields = "id, name, picture.type(small)"
    
    @IBOutlet weak var friendslistView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setUpInitialView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpInitialView() {
        
        self.userEmail.text = resultDataDictionary["email"] as?
            String ?? " "
        self.userName.text = resultDataDictionary["name"] as? String ?? ""
        if let dictonary1 = resultDataDictionary["picture"] {
            if let dictonary2 = (dictonary1 as AnyObject).value(forKey: "data"){
                if let urlString = (dictonary2 as AnyObject).value(forKey: "url") as? String {
                    //Set Profile Image
                    let url:NSURL = NSURL(string: urlString) ?? NSURL()
                    do {
                        let data:NSData = try NSData(contentsOf: url as URL)
                        self.profileImageView.image = UIImage(data: data as Data)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        
        let coverImageURL = (resultDataDictionary as NSDictionary).value(forKeyPath: "cover.source") as? String ?? ""
        //Set Cover Image
        let url:NSURL = NSURL(string: coverImageURL) ?? NSURL()
        do {
            let data:NSData = try NSData(contentsOf: url as URL)
            self.coverImageView.image = UIImage(data: data as Data)
        }
        catch {
            print(error)
        }
        //Fetch Friends List
        guard let friendsArray = (resultDataDictionary as NSDictionary).value(forKeyPath: "friends.data") as? [[String:AnyObject]]
            else {
                return
        }
        
        for friends:[String:AnyObject] in friendsArray {
            
            self.userInfo("\(friends["id"]!)" ,{ (response: AnyObject?,error: NSError?) in
                if error == nil
                {
                    let dict = response as! Dictionary<String, Any>
                    self.friendsList = dict["data"] as! [[String : AnyObject]]
                    
                    DispatchQueue.main.async {
                        self.friendslistView.reloadData()
                    }
                }
                
            })
        }
    }
    
    func userInfo(_ friendID:String, _ completion:((_ response: AnyObject?, _ error: NSError?) -> Void)?) {
        
        let fbRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters:  ["fields": "id,name,picture"])
        let _ = fbRequest?.start(completionHandler: { (connection, result, error) in
            if let block = completion {
                block(result as AnyObject?,error as NSError?)
            }
        })
    }
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Friends List"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserDetailsTableViewCell
        
        
        cell.selectionStyle = .none
        let userDict = friendsList[indexPath.row]
        cell.userName.text = userDict["name"] as? String ?? ""
        let profileImageURL = (userDict as NSDictionary).value(forKeyPath: "picture.data.url") as? String ?? ""
        cell.profileImageView.sd_setImage(with: URL(string: profileImageURL), placeholderImage: UIImage(named:"ProfilePicPlaceholder") , options: .retryFailed, completed: { (image, error, cacheType, url) in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    cell.profileImageView.image = image
                }
            }
            cell.profileImageView.setShowActivityIndicator(false)
        })
        return cell
    }
}
