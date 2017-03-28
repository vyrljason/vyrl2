//
//  WelcomeViewController.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 3/28/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class WelcomeViewController: UIViewController, HavingNib {
    static let nibName: String = "WelcomeViewController"

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.backgroundColor = UIColor.rouge
        signupButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor.pinkishRed
        loginButton.setTitleColor(UIColor.white, for: .normal)
        
        if let fileURL: URL = Bundle.main.url(forResource: "registrationvideo", withExtension: "mov") {
            player = AVPlayer(url: fileURL)
            playerLayer = AVPlayerLayer(player: player)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logoImageView.image = UIImage(named: "mainLogo")
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let playerLayer = playerLayer {
            playerLayer.frame = backgroundView.bounds
            backgroundView.layer.addSublayer(playerLayer)
            loopVideo(videoPlayer: player)
        }
    }
    
    func loopVideo(videoPlayer: AVPlayer?) {
        NotificationCenter.default.addObserver(self, selector: #selector(videoLooped), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        videoPlayer?.play()
    }
    
    func videoLooped() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

protocol WelcomeControllerMaking {
    static func make(using listener: AuthorizationListener) -> WelcomeViewController
}

enum WelcomeControllerFactory: WelcomeControllerMaking {
    static func make(using listener: AuthorizationListener) -> WelcomeViewController {
        return WelcomeViewController()
    }
}
