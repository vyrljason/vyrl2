//
//  SignupPasswordTableViewCell.swift
//  Vyrl
//
//  Created by Gene Crucean on 6/6/16.
//  Copyright © 2016 Vyrl. All rights reserved.
//

import UIKit

class SignupPasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passIsValidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        passIsValidLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func passwordTextFieldEditingChanged(sender: UITextField) {
        
        if let pass = sender.text {
            // Check if pass is valid.
            if pass.isValidPassword {
                SignupDataManager.sharedInstance.password = sender.text?.removeWhitespacesAndNewlines()
                passIsValidLabel.text = "👍🏻"
            }
            else {
                SignupDataManager.sharedInstance.password = nil
                passIsValidLabel.text = "👎🏻"
            }
            
            // Reset validity indicator.
            if pass.length == 0 {
                passIsValidLabel.text = ""
            }
        }
    }
}
