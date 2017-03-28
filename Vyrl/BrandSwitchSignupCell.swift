//
//  BrandSwitchSignupCell.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 8/1/16.
//  Copyright © 2016 Vyrl. All rights reserved.
//

import UIKit

class BrandSwitchSignupCell: UITableViewCell {

    @IBOutlet weak var brandInfoLabel: UILabel!
    @IBOutlet weak var brandSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
