//
//  BaseCollectionViewCell.swift
//  emojis
//
//  Created by Yuri Pedroso on 05/04/21.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func initialize(url: URL) {
        imageView.setImageView(url: url)
        imageView.setImageViewLayerProperties()
    }
}
