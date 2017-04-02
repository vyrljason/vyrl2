//
//  FormView.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/2/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let underlineColor: UIColor = .warmGrey
    static let errorColor: UIColor = .pinkishRed
}

@IBDesignable
final class FormView: UIView, HavingNib, ValidityIndicating {
    static let nibName: String = "FormView"
    
    @IBOutlet private(set) weak var title: UILabel!
    @IBOutlet private(set) weak var value: UITextField!
    @IBOutlet private(set) weak var underline: UIView!
    
    func presentValidation(status: ValidationStatus) {
        underline.backgroundColor = status == .valid ? Constants.underlineColor : Constants.errorColor
    }
}
