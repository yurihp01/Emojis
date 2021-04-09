//
//  BaseCollectionViewCell.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Functions
    func initialize(url: URL) {
        imageView.setImageView(url: url)
        imageView.setImageViewLayerProperties()
    }
}
