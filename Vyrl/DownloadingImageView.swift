//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Kingfisher

private struct Constants {
    static let fastTransitionDuration: TimeInterval = 0.1
}

protocol DownloadableImageRendering {
    func fetchImage(using imageFetcher: ImageFetching, placeholder: UIImage?, animated: Bool)
    func cancelImageFetching(using placeholder: UIImage?)
}

final class DownloadingImageView: UIImageView, DownloadableImageRendering {

    weak var imageFetcher: ImageFetching?

    func fetchImage(using imageFetcher: ImageFetching, placeholder: UIImage? = nil, animated: Bool = true) {
        image = placeholder
        self.imageFetcher = imageFetcher
        self.imageFetcher?.fetchImage { [weak self] result in
            guard let `self` = self else { return }

            result.on(success: { image in
                self.contentMode = .scaleAspectFill
                if animated {
                    UIView.transition(with: self,
                                      duration: Constants.fastTransitionDuration,
                                      options: .transitionCrossDissolve,
                                      animations: { self.image = image },
                                      completion: nil)
                } else {
                    self.image = image
                }
            })
        }
    }

    func cancelImageFetching(using placeholder: UIImage?) {
        image = placeholder
        imageFetcher?.cancel()
    }
}
