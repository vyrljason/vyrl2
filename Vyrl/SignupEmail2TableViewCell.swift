//
//  SignupEmail2TableViewCell.swift
//  Vyrl
//
//  Created by Gene Crucean on 6/6/16.
//  Copyright © 2016 Vyrl. All rights reserved.
//

import UIKit

class SignupEmail2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func emailTextFieldEditingChanged(sender: UITextField) {
        SignupDataManager.sharedInstance.email2 = sender.text?.removeWhitespacesAndNewlines()
    }
}
