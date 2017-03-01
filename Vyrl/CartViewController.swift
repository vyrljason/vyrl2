//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct CartSummaryRenderable {
    let summary: String
    let price: String
    let summaryVisible: Bool

    init(from model: CartSummary) {
        summaryVisible = model.productsCount > 0
        price = model.value.asMoneyWithDecimals
        let summaryFormat = NSLocalizedString("cart.summaryFormat", comment: "") as NSString
        summary = NSString(format: summaryFormat, model.productsCount, model.brandsCount) as String
    }
}

protocol CartSummaryRendering: class {
    func render(_ renderable: CartSummaryRenderable)
}

final class CartViewController: UIViewController, HavingNib {

    private enum Constants {
        static let title = NSLocalizedString("cart.title", comment: "")
    }

    static var nibName: String = "CartViewController"

    private let interactor: CartInteracting

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var summaryLabel: UILabel!
    @IBOutlet fileprivate weak var price: UILabel!
    @IBOutlet fileprivate weak var summaryView: UIView!

    init(interactor: CartInteracting) {
        self.interactor = interactor
        super.init(nibName: CartViewController.nibName, bundle: nil)
        title = Constants.title
        interactor.projector = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        interactor.use(collectionView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        interactor.viewDidAppear()
    }
}

extension CartViewController: CartSummaryRendering {
    func render(_ renderable: CartSummaryRenderable) {
        summaryView.isHidden = !renderable.summaryVisible
        price.text = renderable.price
        summaryLabel.text = renderable.summary
    }
}
