//
//  TableHeaderCell.swift
//  Vyrl
//
//  Created by Kamil Ziętek on 03.03.2017.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol TableHeaderCellRendering {
    func render(_ renderable: TableHeaderRenderable)
}

class TableHeaderCell: UITableViewCell, HavingNib, TableHeaderCellRendering {
    static let nibName = "TableHeaderCell"

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var asterisk: UILabel!
    
    func render(_ renderable: TableHeaderRenderable) {
        headerLabel.text = renderable.text
        asterisk.isHidden = renderable.mandatory
    }
}
