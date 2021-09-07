//
//  PieceCell.swift
//  Composers
//
//  Created by Enoch Chan on 5/26/21.
//

import UIKit
import AVFoundation

class PieceCell: UITableViewCell, AVAudioPlayerDelegate {
    
    @IBOutlet weak var pieceName: UILabel!
    @IBOutlet weak var composerName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    var piece: Piece? {
        didSet {
            // this code will run anytime a Piece gets assigned
            self.pieceName.text = piece?.name
            self.composerName.text = piece?.composer
            
            DispatchQueue.global(qos: .userInitiated).async {
                let url = URL(string: self.piece!.url)!
                let playerItem:AVPlayerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: playerItem)
                DispatchQueue.main.async {
                    self.playButton!.addTarget(self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside)
                }
            }
        }
    }
    
    @objc func playButtonTapped(_ sender:UIButton) {
        if player?.rate == 0
        {
            player!.play()
            playButton!.setTitle("Pause", for: UIControl.State.normal)
        } else {
            player!.pause()
            playButton!.setTitle("Play", for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
