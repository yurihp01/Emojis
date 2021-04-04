//
//  AvatarCell.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit
import Kingfisher

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    func setImageView(url: URL?) {
        guard let url = url else { print("URL not found"); return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage, .fromMemoryCacheOrRefresh, .onFailureImage(.remove), .processor(processor)])
        setImageViewLayerProperties()
    }
    
    private func setImageViewLayerProperties() {
        avatarImage.layer.cornerRadius = 8.0
        avatarImage.clipsToBounds = true
        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.layer.borderWidth = 1.5
    }
}
