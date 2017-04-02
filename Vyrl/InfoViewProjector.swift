//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol InfoViewProjecting {
    weak var presenter: (ViewContainer & LayoutGuideHaving)? { get set }
    func display()
}

final class InfoViewProjector: InfoViewProjecting {
    weak var presenter: (ViewContainer & LayoutGuideHaving)?
    fileprivate let renderable: InfoViewRenderable

    init(renderable: InfoViewRenderable) {
        self.renderable = renderable
    }

    func display() {
        guard let presenter = presenter else { return }
        let infoView = InfoView.fromNib(translatesAutoresizingMaskIntoConstraints: false)
        infoView.render(renderable: renderable)
        infoView.pinToEdges(of: presenter)
    }
}
