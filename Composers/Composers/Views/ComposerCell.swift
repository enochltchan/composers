//
//  ComposerCell.swift
//  Composers
//
//  Created by Enoch Chan on 4/3/21.
//

import UIKit

class ComposerCell: UITableViewCell {

    @IBOutlet weak var composerNameLabel: UILabel!
    @IBOutlet weak var composerPeriodLabel: UILabel!
    @IBOutlet weak var composerImageView: UIImageView!
    
    var composer: Composer? {
        didSet {
            // this code will run anytime a Composer gets assigned
            self.composerNameLabel.text = composer?.name
            self.composerPeriodLabel.text = composer?.period
            
            DispatchQueue.global(qos: .userInitiated).async {
                let composerImageData = NSData(contentsOf: URL(string: self.composer!.imageUrl)!)
                DispatchQueue.main.async {
                    self.composerImageView.image = UIImage(data: composerImageData as! Data)
                    self.composerImageView.layer.cornerRadius = self.composerImageView.frame.width / 2
                }
            }
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
