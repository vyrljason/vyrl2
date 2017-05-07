//
//  DeepLinkManager.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 5/7/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol DeepLinkManagerDelegate {
    func linkToBrand(brand: Brand)
    func linkToCollab(collab: Collab)
}

// As an Influencer I can receive push notification with an invite from brand to visit it's store (clicking redirects me to brand store details)
// As an Influencer I can receive push notification with notification about order status change (clicking redirects me to collabs/chat)

class DeepLinkManager {
    fileprivate let credentialsProvider: APICredentialsProviding

    var delegate: DeepLinkManagerDelegate?
    
    init(credentialsProvider: APICredentialsProviding) {
        self.credentialsProvider = credentialsProvider
    }
    
    func handleOpenUrl(url: URL, application: UIApplication) -> Bool {
        if credentialsProvider.userAccessToken == nil {
            // user not authenticated, login screen will be shown
            return false
        }
        
        guard let urlHost = url.host else {
            return false
        }
        switch urlHost {
        case "brand":
            delegate?.linkToBrand(brand: Brand(id: "444", name: "TMP", description: "TMP TMP TMP", submissionsCount: 4, coverImageURL: nil))
        case "collab":
            delegate?.linkToCollab(collab: Collab(chatRoomId: "randomID", brandName: "TMP", chatRoom: ChatRoom(brandId: "444", influencerId: "444", lastMessage: "4q452", lastActivity: Date(), collabStatus: CollabStatus.contentReview, unreadMessages: 3)))
        default:
            return false
        }
        
        return true
    }
}
