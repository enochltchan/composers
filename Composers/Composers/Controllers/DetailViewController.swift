//
//  DetailViewController.swift
//  Composers
//
//  Created by Enoch Chan on 4/16/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var composerImageDetailView: UIImageView!
    
    @IBOutlet weak var composerNameDetailView: UILabel!
    
    @IBOutlet weak var composerPeriodDetailView: UILabel!
    
    @IBOutlet weak var viewBiographyDetailViewLink: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
     
    @IBOutlet weak var hearCompositionsView: UIButton!
    
    var composer: Composer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(composer)
        
        self.composerNameDetailView.text = composer?.name
        self.composerPeriodDetailView.text = composer?.period

        DispatchQueue.global(qos: .userInitiated).async {
            let composerImageData = NSData(contentsOf: URL(string: self.composer!.imageUrl)!)
            DispatchQueue.main.async {
                self.composerImageDetailView.image = UIImage(data: composerImageData as! Data)
            }
        }
        
        // Tap gesture recognizers
        let biographyTap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.biographyTapFunction))

        // Gesture recognizer Label
        viewBiographyDetailViewLink.isUserInteractionEnabled = true
        viewBiographyDetailViewLink.addGestureRecognizer(biographyTap)
        
//        // Tap gesture recognizers
//        let musicTap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.musicTapFunction))
//
//        // Gesture recognizer Label
//        hearCompositions.isUserInteractionEnabled = true
//        hearCompositions.addGestureRecognizer(musicTap)
    }
    
    @IBAction func biographyTapFunction(sender: UIButton) {
        let biographyUrl = URL(string: composer.biography)!
        webView.load(URLRequest(url: biographyUrl))
        webView.allowsBackForwardNavigationGestures = true
        webView.isHidden = false
    }
    
//    @IBAction func musicTapFunction(sender: UIButton) {
//        self.performSegue(withIdentifier: "musicView", sender: self)
//    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destination = segue.destination as? MusicViewController else { return }
        
//        let confirmedComposer = composer
        destination.composer = composer
    }
    

}
