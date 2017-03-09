//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import Fakery

final class ProductDetailsGalleryDataSourceTest: XCTestCase {
    var collectionViewMock: CollectionViewMock!
    var product: Product!
    var subject: ProductDetailsGalleryDataSource!
    
    override func setUp() {
        collectionViewMock = CollectionViewMock()
        let imageArray = (0..<5).map { _ in VyrlFaker.faker.productImage() }
        product = VyrlFaker.faker.product(images: imageArray)
        subject = ProductDetailsGalleryDataSource(product: product)
    }
    
    func test_numberOfItems_matchesImageCount() {
        let cellCount: Int = subject.collectionView(collectionViewMock, numberOfItemsInSection: 0)
        XCTAssertEqual(cellCount, product.images.count)
    }
}
