//
//  SignupUsernameTableViewCell.swift
//  Vyrl
//
//  Created by Gene Crucean on 6/6/16.
//  Copyright © 2016 Vyrl. All rights reserved.
//

import UIKit

class SignupUsernameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func usernameTextFieldEditingChanged(sender: UITextField) {
        if let text = sender.text {
            let strippedText = text.removeNonAlphanumericForVYRL().removeWhitespacesAndNewlines()
            if strippedText.length > 0 {
                let newText = text.replacingOccurrences(of: " ", with: "_").removeWhitespacesAndNewlines()
                sender.text = newText
                SignupDataManager.sharedInstance.username = newText
            }
            else {
                SignupDataManager.sharedInstance.username = nil
            }
            sender.text = strippedText
        }
    }
}
