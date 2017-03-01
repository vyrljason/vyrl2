//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

enum LeftMenuInteractorFactory {

    private enum Constants {
        static let titleAttributes: [String: Any] = [:] //This should be adjusted by the final design
        static let descriptionAttributes: [String: Any] = [:] //This should be adjusted by the final design
        static let noDataTitle = NSLocalizedString("No categories", comment: "")
        static let noDataDescription = NSLocalizedString("Sorry, there are no categories at the moment.", comment: "")
        static let networkingErrorTitle = NSLocalizedString("Something went wrong", comment: "")
        static let networkingErrorDescription = NSLocalizedString("Please contact the administrator.", comment: "")
    }

    static func make() -> LeftMenuInteractor {

        let noData = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.noDataTitle,
                                                                         attributes: Constants.titleAttributes),
                                               description: NSAttributedString(string: Constants.noDataDescription,
                                                                               attributes: Constants.descriptionAttributes))
        let error = EmptyCollectionRenderable(title: NSAttributedString(string: Constants.networkingErrorTitle,
                                                                        attributes: Constants.titleAttributes),
                                              description: NSAttributedString(string: Constants.networkingErrorDescription,
                                                                              attributes: Constants.descriptionAttributes))

        let modeMap: [EmptyCollectionMode : EmptyCollectionRenderable] = [ .error: error, .noData: noData ]
        let emptyCollectionHandler = EmptyCollectionViewHandler(modeToRenderable: modeMap)
        let resource = Service<CategoriesResourceMock>(resource: CategoriesResourceMock())
        let service = CategoriesService(resource: resource)
        let credentialsStorage = CredentialsStorage()
        let credentialsProvider = APICredentialsProvider(storage: credentialsStorage)
        let categoriesDataSource: CategoriesDataSource = CategoriesDataSource(service: service,
                                                                              emptyTableHandler: emptyCollectionHandler)
        return LeftMenuInteractor(dataSource: categoriesDataSource, credentialsProvider: credentialsProvider)
    }
}
