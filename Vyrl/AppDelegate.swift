//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase
import FirebaseAuth

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private var rootNavigation: RootNavigation!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpAnalytics()
        setUpAPIConfiguration()
        setUpChatTokenRepository()
        setUpFirebase()
        setUpRootNavigation()
        return true
    }

    private func setUpRootNavigation() {
        rootNavigation = RootNavigationBuilder().build()
        rootNavigation?.showInitialViewController(animated: false)
    }

    private func setUpAnalytics() {
        Fabric.with([Crashlytics.self])
    }

    private func setUpAPIConfiguration() {
        guard let apiConfiguration = try? APIConfiguration() else { fatalError("Could not retrieve API configuration") }
        ServiceLocator.resourceConfigurator = ResourceConfiguratorFactory.make(using: apiConfiguration)
    }

    private func setUpChatTokenRepository() {
        ServiceLocator.chatTokenRepository = ChatTokenRepositoryFactory.make(using: ServiceLocator.resourceConfigurator.resourceController)
    }

    private func setUpFirebase() {
        FIRApp.configure()
        guard let authenticator = FIRAuth.auth() else { return }
        ServiceLocator.chatAuthenticator = ChatAuthenticator(chatTokenRepository: ServiceLocator.chatTokenRepository, authenticator: authenticator)
        ServiceLocator.chatAuthenticator.authenticateUser()
    }
}
