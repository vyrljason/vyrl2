//
//  SignupInstagramTableViewCell.swift
//  Vyrl
//
//  Created by Gene Crucean on 6/6/16.
//  Copyright © 2016 Vyrl. All rights reserved.
//

import UIKit

class SignupInstagramTableViewCell: UITableViewCell {

    @IBOutlet weak var instagramUsernameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func instagramTextFieldEditingChanged(sender: UITextField) {
        if let text = sender.text {
            let strippedText = text.removeNonAlphanumericForIG().removeWhitespacesAndNewlines()
            
            if strippedText.length > 0 {
                SignupDataManager.sharedInstance.platform = "instagram"
                SignupDataManager.sharedInstance.platformUsername = strippedText
            }
            else {
                SignupDataManager.sharedInstance.platformUsername = nil
            }
            sender.text = strippedText
        }
    }
}
