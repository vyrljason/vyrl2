//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let initialNavigation = InitialNavigation(mainView: BrandsViewControllerFactory.make(),
                                                      leftMenu: LeftMenuViewController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializeAnalytics()
        initialNavigation.showInitialViewController()
        return true
    }

    private func initializeAnalytics() {
        Fabric.with([Crashlytics.self])
    }
}
