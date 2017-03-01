//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension UIBezierPath {
    static var vyrlVLetter: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 42.86, y: 9.81))
        path.addLine(to: CGPoint(x: 38.19, y: 2.85))
        path.addLine(to: CGPoint(x: 36.51, y: 2.85))
        path.addLine(to: CGPoint(x: 42.16, y: 11.13))
        path.addLine(to: CGPoint(x: 42.16, y: 16.52))
        path.addLine(to: CGPoint(x: 43.51, y: 16.52))
        path.addLine(to: CGPoint(x: 43.51, y: 11.11))
        path.addLine(to: CGPoint(x: 49.17, y: 2.85))
        path.addLine(to: CGPoint(x: 47.55, y: 2.85))
        path.addLine(to: CGPoint(x: 42.86, y: 9.81))
        path.close()
        return path
    }

    static var vyrlYLetter: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 22.35, y: 13.96))
        path.addLine(to: CGPoint(x: 16.18, y: 2.85))
        path.addLine(to: CGPoint(x: 14.64, y: 2.85))
        path.addLine(to: CGPoint(x: 22.35, y: 16.73))
        path.addLine(to: CGPoint(x: 30.07, y: 2.85))
        path.addLine(to: CGPoint(x: 28.53, y: 2.85))
        path.addLine(to: CGPoint(x: 22.35, y: 13.96))
        path.close()
        return path
    }

    static var vyrlRLetter: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 75.58, y: 15.19))
        path.addLine(to: CGPoint(x: 75.58, y: 2.85))
        path.addLine(to: CGPoint(x: 74.23, y: 2.85))
        path.addLine(to: CGPoint(x: 74.23, y: 16.52))
        path.addLine(to: CGPoint(x: 83.07, y: 16.52))
        path.addLine(to: CGPoint(x: 83.07, y: 15.19))
        path.addLine(to: CGPoint(x: 75.58, y: 15.19))
        path.close()
        return path
    }

    static var vyrlLLetter: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 65.9, y: 6.87))
        path.addLine(to: CGPoint(x: 65.9, y: 6.83))
        path.addCurve(to: CGPoint(x: 61.14, y: 2.85), controlPoint1: CGPoint(x: 65.9, y: 4.45), controlPoint2: CGPoint(x: 63.99, y: 2.85))
        path.addLine(to: CGPoint(x: 56.59, y: 2.85))
        path.addLine(to: CGPoint(x: 56.59, y: 4.18))
        path.addLine(to: CGPoint(x: 61.09, y: 4.18))
        path.addCurve(to: CGPoint(x: 64.55, y: 6.87), controlPoint1: CGPoint(x: 63.26, y: 4.18), controlPoint2: CGPoint(x: 64.55, y: 5.18))
        path.addLine(to: CGPoint(x: 64.55, y: 6.9))
        path.addCurve(to: CGPoint(x: 61.03, y: 9.72), controlPoint1: CGPoint(x: 64.55, y: 8.62), controlPoint2: CGPoint(x: 63.17, y: 9.72))
        path.addLine(to: CGPoint(x: 56.59, y: 9.72))
        path.addLine(to: CGPoint(x: 56.59, y: 11.03))
        path.addLine(to: CGPoint(x: 60.81, y: 11.03))
        path.addLine(to: CGPoint(x: 64.81, y: 16.44))
        path.addLine(to: CGPoint(x: 64.87, y: 16.52))
        path.addLine(to: CGPoint(x: 66.58, y: 16.52))
        path.addLine(to: CGPoint(x: 62.33, y: 10.8))
        path.addCurve(to: CGPoint(x: 65.9, y: 6.87), controlPoint1: CGPoint(x: 64.57, y: 10.37), controlPoint2: CGPoint(x: 65.9, y: 8.92))
        path.close()
        return path
    }
}
