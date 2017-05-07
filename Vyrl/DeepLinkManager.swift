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


/*
 func handleOpenUrl(url : NSURL, application: UIApplication) {
 
 if let urlHost = url.host where urlHost == CONSTANTS.GENERAL.DEEPLINKING_ROUTES.USER,
 let pathComponent1 = url.pathComponents?[1] where pathComponent1 == CONSTANTS.GENERAL.DEEPLINKING_ROUTES.CHAT,
 let pathComponent2 = url.pathComponents?[2],
 let swipeNavVC = storyboard.instantiateViewControllerWithIdentifier("BaseNavigationController") as? UINavigationController,
 let chatVC = storyboard.instantiateViewControllerWithIdentifier("ChatMessagesTableViewController") as? ChatMessagesTableViewController,
 profile = RealmManager.sharedInstance.getLocalActiveProfile(),
 senderId : Int = pathComponent2.toInt()
 {
 
 var userIDs : [Int] = [profile.vyrlID, senderId]
 userIDs.sortInPlace()
 
 var roomPath : String = ""
 for user in userIDs {
 roomPath.appendContentsOf("\(user)_")
 }
 
 chatVC.senderImageUrl = profile.vyrlAvatarURL
 chatVC.senderId = "\(profile.vyrlID)"
 chatVC.senderDisplayName = profile.vyrlUsername
 chatVC.roomId = roomPath
 
 
 if AuthController.sharedInstance.isChatAuthenticated {
 FirebaseController.sharedInstance.fetchCutoffKeyForRoomAndUser(roomPath, userId: profile.vyrlID, completion: {
 result in
 if let result = result {
 chatVC.cutoffKey = result
 FirebaseController.sharedInstance.fetchOtherUserForRoomId(roomPath, completion: {
 profile in
 guard let profile = profile else {
 return // TODO: THIS IS BAD SHOULD NEVER HAPPEN
 }
 chatVC.title = "@\(profile.vyrlUsername)"
 swipeNavVC.pushViewController(storyboard.instantiateViewControllerWithIdentifier("SwipeViewController"), animated: false)
 swipeNavVC.pushViewController(storyboard.instantiateViewControllerWithIdentifier("ChatConversationsViewController"), animated: false)
 swipeNavVC.pushViewController(chatVC, animated: false)
 })
 } else {
 // TODO: LOG AN ERROR THIS IS BAD
 return
 }
 })
 } else {
 FirebaseController.sharedInstance.authCurrentUser {
 success in
 if success {
 self.handleOpenUrl(url, application: application)
 } else {
 APIManager.sharedInstance.reAuth()
 }
 }
 }
 
 swipeNavVC.navigationBar.tintColor = StyleKit.vyrl_white
 application.keyWindow?.setRootViewController(swipeNavVC)
 
 
 }
 }
 
 */
