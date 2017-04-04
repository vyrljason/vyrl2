//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase

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
        //FIXME: This is really temporary, we need to sign in **after** user login and have designated 
        guard let authenticator = FIRAuth.auth() else { return }
        let decoder = ChatTokenDecoder()
        ServiceLocator.chatAuthenticator = ChatAuthenticator(chatTokenRepository: ServiceLocator.chatTokenRepository,
                                                             authenticator: authenticator,
                                                             tokenDecoder: decoder,
                                                             chatCredentialsStorage: ChatCredentialsStorage())
        ServiceLocator.chatAuthenticator?.authenticateUser { _ in
            //FIXME: This is also temporary, waiting for the whole flow to be finished, then moved after login
            ServiceLocator.unreadMessagesObserver.observeUnreadMessages()
        }
    }
}
