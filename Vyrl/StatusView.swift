//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum CollabStatus: Int, CustomStringConvertible, CustomIntegerConvertible {
    
    private enum Constants {
        static let currentStatusTitle = NSLocalizedString("messages.currentStatus.title", comment: "")
        static let fontSize: CGFloat = 16
    }
    
    case brief = 0
    case productDelivery = 1
    case contentReview = 2
    case publication = 3
    case done = 4
    case waiting = -1
    
    static var allValidStatuses: [CollabStatus] {
        return [CollabStatus.brief, CollabStatus.productDelivery, CollabStatus.contentReview,
                CollabStatus.publication, CollabStatus.done]
    }
    
    var description: String {
        switch self {
        case .brief:
            return "1. brief"
        case .productDelivery:
            return "2. productDelivery"
        case .contentReview:
            return "3. contentReview"
        case .publication:
            return "4. publication"
        case .done:
            return "5. done"
        case .waiting:
            return "Waiting for brand response..."
        }
    }
    
    var integerValue: Int {
        return self.rawValue
    }
    
    var isValid: Bool {
        switch self {
        case .waiting:
            return false
        default:
            return true
        }
    }
    
    var attributedText: NSAttributedString {
        return NSAttributedString(string: self.description)
    }
    
    var boldAttributedText: NSAttributedString {
        return NSAttributedString(string: self.description, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: Constants.fontSize)])
    }
    
    var strikedAttributedText: NSAttributedString {
        return NSAttributedString(string: self.description, attributes: [NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue),
                                                                      NSForegroundColorAttributeName: UIColor.warmGrey])
    }
    
    var lightAttributedText: NSAttributedString {
        return NSAttributedString(string: self.description, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: Constants.fontSize, weight: UIFontWeightLight),
                                                                      NSForegroundColorAttributeName: UIColor.warmGrey])
    }
    
    var currentStatusAttributedText: NSAttributedString {
        switch self {
        case .waiting:
            return attributedText
        default:
            let currentStatus = NSMutableAttributedString(string: Constants.currentStatusTitle, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: Constants.fontSize, weight: UIFontWeightLight),
                                                                                                             NSForegroundColorAttributeName: UIColor.warmGrey])
            currentStatus.append(boldAttributedText)
            return currentStatus
        }
    }
}

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
