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
        setUpFirebaseConfiguration()
        setUpAnalytics()
        setUpAPIConfiguration()
        setUpChatTokenRepository()
        setUpFirebaseAuthentication()
        setUpRootNavigation()
        
        if let pushPayload = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [NSObject: AnyObject]
        {
            self.application(application, didReceiveRemoteNotification: pushPayload)
        } else if let deeplinkPayload = launchOptions?[UIApplicationLaunchOptionsKey.url] as? URL {
            
            rootNavigation.deepLinkManager.handleOpenUrl(url: deeplinkPayload, application: application)
        }
        
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
        guard let apiConfiguration = try? APIConfiguration(mode: .Staging) else { fatalError("Could not retrieve API configuration") }
        ServiceLocator.resourceConfigurator = ResourceConfiguratorFactory.make(using: apiConfiguration)
    }
    
    private func setUpChatTokenRepository() {
        ServiceLocator.chatTokenRepository = ChatTokenRepositoryFactory.make(using: ServiceLocator.resourceConfigurator.resourceController)
    }
    
    private func setUpFirebaseConfiguration() {
        FIRApp.configure()
    }
    
    private func setUpFirebaseAuthentication() {
        guard let authenticator = FIRAuth.auth() else { return }
        ServiceLocator.chatAuthenticator = ChatAuthenticator(chatTokenRepository: ServiceLocator.chatTokenRepository,
                                                             authenticator: authenticator,
                                                             tokenDecoder: ChatTokenDecoder(),
                                                             chatCredentialsStorage: ChatCredentialsStorage(),
                                                             unreadMessagesObserver: ServiceLocator.unreadMessagesObserver)
        guard let _ = FIRAuth.auth()?.currentUser else { return }
        ServiceLocator.unreadMessagesObserver.observeUnreadMessages()
    }
    
    // MARK: - Push notification and deeplinking
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // stub for local noti
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if application.applicationState == UIApplicationState.active {
            // if active but a chat push -- badge chat
            // TODO
            return
        }
        
        // Add badge to app icon.
        application.applicationIconBadgeNumber = 1
        
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            if let _ = aps["alert"] as? [String: AnyObject] {
            }
            
            // Set badge count if it exists.
            if let badgeCount = aps["badge"] as? Int {
                application.applicationIconBadgeNumber = badgeCount
            }
            
            // Fire off the deep linking from the passed in url.
            if let urlString = aps["url"] as? String,
                let url = URL(string: urlString) {
                rootNavigation.deepLinkManager.handleOpenUrl(url: url, application: application)
            }
        }
    }
    
    
    // MARK: - DeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let characterSet = CharacterSet.init(charactersIn: "<>")
        let fixedDeviceToken = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "")
        // Set device token.
        Answers.logCustomEvent(withName: "Register For Remote Notifications from App Delegate", customAttributes:["deviceToken": "\(fixedDeviceToken)"])
        let resourceController = ServiceLocator.resourceConfigurator.resourceController
        let pushResource = PushNotificationResource(controller: resourceController)
        pushResource.register(token: fixedDeviceToken, completion: {
            result in
            result.map(success: {
                didSucceed in
                if !didSucceed {
                    // TODO: re register here
                }
            }, failure: {
                error in
                // TODO: proper error handling
            })
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
}
