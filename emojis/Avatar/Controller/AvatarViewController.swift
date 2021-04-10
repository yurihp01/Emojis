//
//  AvatarViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit

final class AvatarViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var avatarUrls: [String] = []
    
    var viewModel: AvatarViewModelProtocol?
    weak var coordinator: AvatarCoordinator?
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAvatars()
        setCollectionView()
    }
    
    // MARK: - Functions
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.accessibilityIdentifier = Constants.avatarList
    }
    
    private func getAvatars() {
        viewModel?.getAvatarsUrl(completion: { (urls, error) in
            if let urls = urls {
                self.avatarUrls = urls
                collectionView.reloadData()
            } else {
                showAlert(message: error?.localizedDescription)
            }
        })
    }
}

// MARK: - Extensions
extension AvatarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minSpace: CGFloat = 10
        let size = (collectionView.frame.size.width - minSpace) / 5
        return CGSize(width: size, height: size)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cell, for: indexPath) as? BaseCollectionViewCell, !avatarUrls.isEmpty, let url = URL(string: avatarUrls[indexPath.row]) {
            cell.initialize(url: url)
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cell, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.deleteAvatar(url: avatarUrls[indexPath.row]) { error in
            if error == nil {
                avatarUrls.remove(at: indexPath.row)
                getAvatars()
            } else {
                showAlert(message: error?.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.header, for: indexPath)
            return header
        }
        
        return UICollectionReusableView()
    }
}
