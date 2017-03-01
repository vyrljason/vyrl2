//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class StyleKit {
    private enum Constants {
        static let miterLimit: CGFloat = 4
        static let useEvenOddFill = true
        static let fillColor = UIColor.dullWhite
        static let navigationBarLogoSize = CGSize(width: 97, height: 20)
    }

    private struct Cache {
        static var navigationBarLogo: UIImage?
    }

    class var navigationBarLogo: UIImage {
        if let logo = Cache.navigationBarLogo { return logo }

        UIGraphicsBeginImageContextWithOptions(Constants.navigationBarLogoSize, false, 0)
        StyleKit.drawNavigationBarLogo()
        Cache.navigationBarLogo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return Cache.navigationBarLogo!
    }

    private class func drawNavigationBarLogo() {
        let vLetterPath = UIBezierPath.vyrlVLetter
        let yLetterPath = UIBezierPath.vyrlYLetter
        let rLetterPath = UIBezierPath.vyrlRLetter
        let lLetterPath = UIBezierPath.vyrlLLetter

        [vLetterPath, yLetterPath, rLetterPath, lLetterPath].forEach { (path) in
            path.miterLimit = Constants.miterLimit
            path.usesEvenOddFillRule = Constants.useEvenOddFill
            Constants.fillColor.setFill()
            path.fill()
        }
    }
}
