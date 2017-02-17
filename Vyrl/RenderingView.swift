//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol RenderingView {
    associatedtype Renderable
    func render(renderable: Renderable)
}
