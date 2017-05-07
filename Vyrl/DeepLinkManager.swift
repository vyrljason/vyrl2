//
//  DeepLinkManager.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 5/7/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

class DeepLinkManager {
    fileprivate let credentialsProvider: APICredentialsProviding

    init(credentialsProvider: APICredentialsProviding) {
        self.credentialsProvider = credentialsProvider
    }
    
    func handleOpenUrl(url: URL, application: UIApplication) {
        if credentialsProvider.userAccessToken == nil {
            // user not authenticated, login screen will be shown
            return
        }
        
       // As an Influencer I can receive push notification with an invite from brand to visit it's store (clicking redirects me to brand store details)
        // As an Influencer I can receive push notification with notification about order status change (clicking redirects me to collabs/chat)
        
    }
}
