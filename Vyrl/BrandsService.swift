//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum BrandsError: Error {
    case unknown
}

typealias BrandsResultClosure = (Result<[Brand], BrandsError>) -> Void

protocol BrandsFetching {
    func brands(with limit: Int, offset: Int, completion: @escaping BrandsResultClosure)
}

protocol BrandsHaving {
    func reset()
    func nextBrandsPage(completion: @escaping BrandsResultClosure)
}

final class BrandsService: BrandsHaving {

    let resource: BrandsFetching

    fileprivate let pageSize: Int
    fileprivate var currentPage: Int = 0
    fileprivate var offset: Int {
        return currentPage * pageSize
    }
    fileprivate var brands: [Brand] = []

    init(resource: BrandsFetching, pageSize: Int = 20) {
        self.resource = resource
        self.pageSize = pageSize
    }

    func reset() {
        currentPage = 0
        brands.removeAll()
    }

    func nextBrandsPage(completion: @escaping BrandsResultClosure) {
        resource.brands(with: pageSize, offset: offset) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let newBrands):
                self.brands.append(contentsOf: newBrands)
                self.currentPage += 1
                completion(.success(newBrands))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
