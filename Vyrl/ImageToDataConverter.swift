//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ImageToDataConverting {
    func convert(image: UIImage) -> Data?
}

final class ImageToDataConverter: ImageToDataConverting {
    func convert(image: UIImage) -> Data? {
        return UIImagePNGRepresentation(image)
    }
}
