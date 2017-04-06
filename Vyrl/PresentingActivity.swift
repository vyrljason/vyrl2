//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol PresentingActivity {
    func presentActivity(inView view: UIView)
    func dismissActivity(inView view: UIView)
}

final class ActivityPresenterAdapter: PresentingActivity {
    let activityPresenter: MBProgressHUD.Type
    
    init(activityPresenter: MBProgressHUD.Type = MBProgressHUD.self) {
        self.activityPresenter = activityPresenter
    }
    
    func presentActivity(inView view: UIView) {
        activityPresenter.showAdded(to: view, animated: true)
    }
    
    func dismissActivity(inView view: UIView) {
        activityPresenter.hide(for: view, animated: true)
    }
}
