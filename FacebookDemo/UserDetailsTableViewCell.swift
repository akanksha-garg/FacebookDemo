//
//  UserDetailsTableViewCell.swift
//  FacebookDemo
//
//  Created by Akanksha on 04/06/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = 10.0
        profileImageView.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
