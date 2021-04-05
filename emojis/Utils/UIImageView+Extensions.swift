//
//  BaseViewCellCollectionViewCell.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import UIKit

extension UIImageView {
    func setImageView(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage, .fromMemoryCacheOrRefresh, .onFailureImage(.remove)])
        setImageViewLayerProperties()
    }
    
    private func setImageViewLayerProperties() {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
    }
}
