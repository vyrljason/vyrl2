//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension CALayer {
    func drawBottomBorder(for view: UIView, using color: UIColor, with height: CGFloat) -> CALayer {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0,
                              y: frame.size.height - height,
                              width: frame.size.width,
                              height: height)
        border.borderWidth = height
        addSublayer(border)
        masksToBounds = true
        return border
    }
}
