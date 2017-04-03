//
//  WelcomeViewController.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 4/1/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import AVFoundation

private enum Constants {
    static let videoResourceName = "WelcomeViewBackgroundVideo"
    static let videoResourceExtension = "mov"
}


final class WelcomeViewController: UIViewController, HavingNib {
    static let nibName: String = "WelcomeViewController"
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!

    private let interactor: WelcomeViewInteracting
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    init(interactor: WelcomeViewInteracting) {
        self.interactor = interactor
        if let fileURL: URL = Bundle.main.url(forResource: Constants.videoResourceName, withExtension: Constants.videoResourceExtension) {
            self.player = AVPlayer(url: fileURL)
            self.playerLayer = AVPlayerLayer(player: player)
        }
        super.init(nibName: WelcomeViewController.nibName, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        playLoop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        stopVideo()
    }

    func playLoop() {
        if let playerLayer = playerLayer {
            //video is AR 0.55
            let videoAR: CGFloat = 0.55
            let desiredVideoWidth = UIScreen.main.bounds.width
            let necessaryVideoHeight = desiredVideoWidth/videoAR
            let heightOffsetToCenter = (UIScreen.main.bounds.height - necessaryVideoHeight)/2
            playerLayer.frame = CGRect(x: 0, y: heightOffsetToCenter, width: desiredVideoWidth, height: necessaryVideoHeight)
            backgroundView.layer.addSublayer(playerLayer)
            loopVideo(videoPlayer: player)
        }
    }
    
    func stopVideo() {
        player?.pause()
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        interactor.didTapLogin()
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        interactor.didTapSignUp()
    }
}
