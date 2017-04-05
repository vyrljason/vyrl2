//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct StatusViewRenderable {
    let status: CollabStatus
}

final class StatusView: UIView {
    
    private enum Constants {
        static let animationDuration: Double = 0.3
    }
    
    fileprivate var stackView: UIStackView!
    fileprivate var mainStatusView: MainStatusView!
    fileprivate var detailViews: [SingleStatusView] = []
    fileprivate var isExpanded: Bool = false
    fileprivate var currentRenderable: StatusViewRenderable = StatusViewRenderable(status: CollabStatus.waiting)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStackView()
        setUpMainStatusView()
        setUpDetailViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpStackView()
        setUpMainStatusView()
        setUpDetailViews()
    }
    
    func setUpStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.pinToEdges(of: self)
    }
    
    func setUpMainStatusView() {
        mainStatusView = MainStatusView.fromNib()
        stackView.addArrangedSubview(mainStatusView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapStatusView))
        tapGesture.delegate = self
        mainStatusView.addGestureRecognizer(tapGesture)
        render(renderable: currentRenderable)
    }
    
    func setUpDetailViews() {
        CollabStatus.allValidStatuses.forEach { _ in
            let singleStatusView = SingleStatusView.fromNib()
            singleStatusView.isHidden = true
            detailViews.append(singleStatusView)
            stackView.addArrangedSubview(singleStatusView)
        }
    }
    
    func didTapStatusView() {
        if isExpanded {
            collapseView()
        } else {
            expandView()
        }
        isExpanded = !isExpanded
        let renderable = MainStatusViewRenderable(status: currentRenderable.status.currentStatusAttributedText,
                                                  isExpanded: isExpanded, arrowHidden: !currentRenderable.status.isValid)
        mainStatusView.render(renderable: renderable)
    }
    
    func expandView() {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let `self` = self else { return }
            let allValidStatuses = CollabStatus.allValidStatuses
            allValidStatuses.forEach { status in
                let renderable = SingleStatusViewRenderable(status: self.properAttributedText(for: status, currentStatus: self.currentRenderable.status),
                                                            showSeparator: status.integerValue != allValidStatuses.endIndex)
                self.detailViews[status.integerValue].render(renderable: renderable)
                self.detailViews[status.integerValue].isHidden = false
            }
        }
    }
    
    func properAttributedText(for status: CollabStatus, currentStatus: CollabStatus) -> NSAttributedString {
        if status.integerValue < currentStatus.integerValue {
            return status.strikedAttributedText
        } else if status.integerValue > currentStatus.integerValue {
            return status.lightAttributedText
        }
        return status.boldAttributedText
    }
    
    func collapseView() {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let `self` = self else { return }
            for view in self.detailViews {
                view.isHidden = true
            }
        }
    }
    
    func render(renderable: StatusViewRenderable) {
        let mainStatusRenderable = MainStatusViewRenderable(status: renderable.status.currentStatusAttributedText,
                                                            isExpanded: isExpanded, arrowHidden: !renderable.status.isValid)
        mainStatusView.render(renderable: mainStatusRenderable)
        currentRenderable = renderable
    }
}

extension StatusView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return currentRenderable.status.isValid
    }
}
