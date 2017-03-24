//
//  StatusView.swift
//  Vyrl
//
//  Created by Wojciech Stasiński on 24/03/2017.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

enum CollabStatus: String {
    
    private enum Constants {
        static let currentStatusTitle = NSLocalizedString("messages.currentStatus.title", comment: "")
        static let fontSize: CGFloat = 16
    }
    
    case brief = "1. brief"
    case productDelivery = "2. productDelivery"
    case contentReview = "3. contentReview"
    case publication = "4. publication"
    case done = "5. done"
    case waiting = "Waiting for brand response..."
    
    static var allValidStatuses: [CollabStatus] {
        return [CollabStatus.brief, CollabStatus.productDelivery, CollabStatus.contentReview,
                CollabStatus.publication, CollabStatus.done]
    }
    
    var statusIndex: Int {
        switch self {
        case .brief:
            return 0
        case .productDelivery:
            return 1
        case .contentReview:
            return 2
        case .publication:
            return 3
        case .done:
            return 4
        default:
            return -1
        }
    }
    
    var isValidStatus: Bool {
        switch self {
        case .waiting:
            return false
        default:
            return true
        }
    }
    
    var attributedText: NSAttributedString {
        return NSAttributedString(string: self.rawValue)
    }
    
    var boldAttributedText: NSAttributedString {
        return NSAttributedString(string: self.rawValue, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: Constants.fontSize)])
    }
    
    var strikedAttributedText: NSAttributedString {
        return NSAttributedString(string: self.rawValue, attributes: [NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue),
                                                                      NSForegroundColorAttributeName: UIColor.warmGrey])
    }
    
    var lightAttributedText: NSAttributedString {
        return NSAttributedString(string: self.rawValue, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: Constants.fontSize, weight: UIFontWeightLight),
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
    fileprivate var stackView: UIStackView!
    fileprivate var mainStatusView: MainStatusView!
    fileprivate var detailViews: [SingleStatusView] = []
    fileprivate var isExpanded: Bool = false
    fileprivate var currentRenderable: StatusViewRenderable = StatusViewRenderable(status: CollabStatus.waiting)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMainStatusView()
        setUpStackView()
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
        for _ in CollabStatus.allValidStatuses {
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
                                                  isExpanded: isExpanded, arrowHidden: !currentRenderable.status.isValidStatus)
        mainStatusView.render(renderable: renderable)
    }
    
    func expandView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` = self else { return }
            let allValidStatuses = CollabStatus.allValidStatuses
            for (index, status) in allValidStatuses.enumerated() {
                let renderable = SingleStatusViewRenderable(status: self.properAttributedText(for: status, currentStatus: self.currentRenderable.status),
                                                            showSeparator: index != allValidStatuses.endIndex)
                self.detailViews[index].render(renderable: renderable)
                self.detailViews[index].isHidden = false
            }
        }
    }
    
    func properAttributedText(for status: CollabStatus, currentStatus: CollabStatus) -> NSAttributedString {
        if status.statusIndex < currentStatus.statusIndex {
            return status.strikedAttributedText
        } else if status.statusIndex > currentStatus.statusIndex {
            return status.lightAttributedText
        }
        return status.boldAttributedText
    }
    
    func collapseView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` = self else { return }
            for view in self.detailViews {
                view.isHidden = true
            }
        }
    }
    
    func render(renderable: StatusViewRenderable) {
        let mainStatusRenderable = MainStatusViewRenderable(status: renderable.status.currentStatusAttributedText,
                                                            isExpanded: isExpanded, arrowHidden: !renderable.status.isValidStatus)
        mainStatusView.render(renderable: mainStatusRenderable)
        currentRenderable = renderable
    }
}

extension StatusView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return currentRenderable.status.isValidStatus
    }
}
