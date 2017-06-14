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
    //video is AR 0.55
    static let videoAspectRatio: CGFloat = 0.55

}


final class WelcomeViewController: UIViewController, HavingNib {
    static let nibName: String = "WelcomeViewController"
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var comingSoonDescriptionLabel: UILabel!

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
        guard let playerLayer = playerLayer else {
            return
        }
        let desiredVideoWidth = UIScreen.main.bounds.width
        let necessaryVideoHeight = desiredVideoWidth/Constants.videoAspectRatio
        let heightOffsetToCenter = (UIScreen.main.bounds.height - necessaryVideoHeight)/2
        playerLayer.frame = CGRect(x: 0, y: heightOffsetToCenter, width: desiredVideoWidth, height: necessaryVideoHeight)
        backgroundView.layer.addSublayer(playerLayer)
        loopVideo(videoPlayer: player)
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
    
    @IBAction private func didTapLogin() {
        interactor.didTapLogin()
    }
    
    @IBAction private func didTapSignUp() {
        interactor.didTapSignUp()
    }

    @IBAction func comingSoonPressed() {
        comingSoonDescriptionLabel.shakeAndScale()
    }

}

extension UIView {
    public func shakeAndScale(shakeOffset: CGFloat = 20, scaleFactor: CGFloat = 1.2) {
        let originalPosition = center
        var leftShakePosition = center
        leftShakePosition.x -= shakeOffset
        var rightShakePosition = center
        rightShakePosition.x += shakeOffset

        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: (1/6), animations: {
                self.center = leftShakePosition
            })
            UIView.addKeyframe(withRelativeStartTime: (1/6), relativeDuration: (1/6), animations: {
                self.center = originalPosition
            })
            UIView.addKeyframe(withRelativeStartTime: (2/6), relativeDuration: (1/6), animations: {
                self.center = rightShakePosition
            })
            UIView.addKeyframe(withRelativeStartTime: (3/6), relativeDuration: (1/6), animations: {
                self.center = originalPosition
            })
            UIView.addKeyframe(withRelativeStartTime: (4/6), relativeDuration: (1/6), animations: {
                self.center = leftShakePosition
            })
            UIView.addKeyframe(withRelativeStartTime: (5/6), relativeDuration: (1/6), animations: {
                self.center = originalPosition
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: (1/2), animations: {
                self.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            })
            UIView.addKeyframe(withRelativeStartTime: (1/2), relativeDuration: (1/2), animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }, completion: nil)

    }
}
