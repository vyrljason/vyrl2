//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Kingfisher

protocol ImageFetching: class, Cancelable {
    func fetchImage(callback: @escaping ImageRetrieverCallback)
}

final class ImageFetcher: ImageFetching {

    fileprivate var url: URL
    fileprivate var retriever: ImageRetrieving
    fileprivate var retrieveTask: ImageRetrievingTask?

    init(url: URL, retriever: ImageRetrieving = ServiceLocator.imageRetriever) {
        self.url = url
        self.retriever = retriever
    }

    func fetchImage(callback: @escaping ImageRetrieverCallback) {
        retrieveTask = retriever.retrieveImage(with: url, callback: callback)
    }

    func cancel() {
        retrieveTask?.cancel()
    }
}
