//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let imageCompression: CGFloat = 0.8
}

protocol ImageToDataConverting {
    func convert(image: UIImage) -> Data?
}

final class ImageToDataConverter: ImageToDataConverting {

    func convert(image: UIImage) -> Data? {
        return UIImageJPEGRepresentation(image, Constants.imageCompression)
    }
}
