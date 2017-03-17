//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Alamofire

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private var rootNavigation: RootNavigation!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializeAnalytics()
        setUpAPIConfiguration()
        setUpChatTokenRepository()
        setUpRootNavigation()
        return true
    }

    private func setUpRootNavigation() {
        rootNavigation = RootNavigationBuilder().build()
        rootNavigation?.showInitialViewController(animated: false)
    }

    private func initializeAnalytics() {
        Fabric.with([Crashlytics.self])
    }

    private func setUpAPIConfiguration() {
        guard let apiConfiguration = try? APIConfiguration() else { fatalError("Could not retrieve API configuration") }
        ServiceLocator.resourceConfigurator = ResourceConfiguratorFactory.make(using: apiConfiguration)
    }

    private func setUpChatTokenRepository() {
        ServiceLocator.chatTokenRepository = ChatTokenRepositoryFactory.make(using: ServiceLocator.resourceConfigurator.resourceController)
    }
}
