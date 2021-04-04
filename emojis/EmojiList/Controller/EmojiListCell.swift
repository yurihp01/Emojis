//
//  EmojiListCell.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit
import Kingfisher

class EmojiListCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiImage: UIImageView!
    
    func setImageView(url: URL?) {
        guard let url = url else { print("URL not found"); return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        emojiImage.kf.indicatorType = .activity
        emojiImage.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage, .fromMemoryCacheOrRefresh, .onFailureImage(.remove), .processor(processor)])
        setImageViewLayerProperties()
    }
    
    private func setImageViewLayerProperties() {
        emojiImage.layer.cornerRadius = 8.0
        emojiImage.clipsToBounds = true
        emojiImage.layer.borderColor = UIColor.white.cgColor
        emojiImage.layer.borderWidth = 1.5
    }
}
