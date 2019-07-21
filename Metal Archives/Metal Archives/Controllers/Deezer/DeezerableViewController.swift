//
//  DeezerableViewController.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 20/07/2019.
//  Copyright © 2019 Thanh-Nhon Nguyen. All rights reserved.
//

import UIKit

enum DeezerableType {
    case album, artist
    
    var requestParameterName: String {
        switch self {
        case .album: return "album"
        case .artist: return "artist"
        }
    }
}

protocol Deezerable {
    var deezerableType: DeezerableType { get }
    var deezerSearchTerm: String { get }
}

class DeezerableViewController: BaseViewController {
    @IBOutlet weak var deezerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDeezerButton()
    }
    
    private func initDeezerButton() {
        deezerButton.layer.masksToBounds = false
        deezerButton.layer.shouldRasterize = true
        deezerButton.layer.rasterizationScale = UIScreen.main.scale
        deezerButton.layer.shadowRadius = 5
        deezerButton.layer.shadowOpacity = 0.7
        deezerButton.layer.shadowOffset = .zero
        deezerButton.layer.shadowColor = Settings.currentTheme.bodyTextColor.cgColor
    }
    
    @IBAction private func deezerButtonTapped() {
        guard let deezerableSelf = self as? Deezerable else { return }
        let deezerResultViewController = UIStoryboard(name: "Deezer", bundle: nil).instantiateViewController(withIdentifier: "DeezerResultViewController") as! DeezerResultViewController
        
        deezerResultViewController.deezerableType = deezerableSelf.deezerableType
        deezerResultViewController.deezerableSearchTerm = deezerableSelf.deezerSearchTerm
        
        navigationController?.pushViewController(deezerResultViewController, animated: true)
    }
}

extension DeezerableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y < 0 {
            // scroll down
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.deezerButton.transform = CGAffineTransform(translationX: 0, y: 300)
            }
            
        } else {
            // scroll up
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.deezerButton.transform = .identity
            }
            
        }
    }
}
