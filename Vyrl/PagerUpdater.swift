//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol PagerUpdating: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

final class PagerUpdater: NSObject, PagerUpdating {

    fileprivate var currentPage: Int = 0
    let pager: UIPageControl
    
    init(pager: UIPageControl) {
        self.pager = pager
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pager.numberOfPages < 1 {
            return
        }
        let contentWidth: CGFloat = scrollView.contentSize.width
        let itemWidth: CGFloat = contentWidth / CGFloat(pager.numberOfPages)
        let focusedX: CGFloat = scrollView.frame.width * 0.5 + scrollView.contentOffset.x
        let page: Int = Int(focusedX / itemWidth)
        if page != currentPage {
            currentPage = page
            DispatchQueue.onMainThread { [weak self] in
                self?.pager.currentPage = page
            }
        }
    }
}
