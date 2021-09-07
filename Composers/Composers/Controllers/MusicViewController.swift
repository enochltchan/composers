//
//  MusicViewController.swift
//  Composers
//
//  Created by Enoch Chan on 5/26/21.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController, AVAudioPlayerDelegate {

    var composer: Composer?
    var player1:AVPlayer?
    var playerItem1:AVPlayerItem?
    var player2:AVPlayer?
    var playerItem2:AVPlayerItem?

    @IBOutlet weak var playButton1: UIButton!
    @IBOutlet weak var pieceTitle1: UILabel!
    
    @IBOutlet weak var playButton2: UIButton!
    @IBOutlet weak var pieceTitle2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 1st piece
        let url1 = URL(string: (composer?.pieceUrls[0])!)
        self.pieceTitle1.text = composer?.pieceNames[0]
        let playerItem1:AVPlayerItem = AVPlayerItem(url: url1!)
        player1 = AVPlayer(playerItem: playerItem1)
        playButton1!.addTarget(self, action: #selector(self.playButtonTapped1(_:)), for: .touchUpInside)
        
        // 2nd piece
        let url2 = URL(string: (composer?.pieceUrls[1])!)
        self.pieceTitle2.text = composer?.pieceNames[1]
        let playerItem2:AVPlayerItem = AVPlayerItem(url: url2!)
        player2 = AVPlayer(playerItem: playerItem2)
        playButton2!.addTarget(self, action: #selector(self.playButtonTapped2(_:)), for: .touchUpInside)

    }

    @objc func playButtonTapped1(_ sender:UIButton) {
        if player1?.rate == 0
        {
            player1!.play()
            playButton1!.setTitle("Pause", for: UIControl.State.normal)
        } else {
            player1!.pause()
            playButton1!.setTitle("Play", for: UIControl.State.normal)
        }
    }
    
    @objc func playButtonTapped2(_ sender:UIButton) {
        if player2?.rate == 0
        {
            player2!.play()
            playButton2!.setTitle("Pause", for: UIControl.State.normal)
        } else {
            player2!.pause()
            playButton2!.setTitle("Play", for: UIControl.State.normal)
        }
    }

}





// source: https://www.advancedswift.com/corners-borders-shadows/#-ibdesignable-ibinspectable-border
@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue

              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = (newValue > 0)
        }
    }
}

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
