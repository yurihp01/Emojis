//
//  AvatarViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit

final class AvatarViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var avatarUrls: [String] = []
    
    var viewModel: AvatarViewModelProtocol?
    weak var coordinator: AvatarCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAvatars()
        setCollectionView()
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func getAvatars() {
        viewModel?.getAvatarsUrl(completion: { (urls, error) in
            if let urls = urls {
                self.avatarUrls = urls
                collectionView.reloadData()
            } else {
                showAlert(error: error)
            }
        })
    }
}

extension AvatarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarUrls.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BaseCollectionViewCell, !avatarUrls.isEmpty, let url = URL(string: avatarUrls[indexPath.row]) {
            cell.initialize(url: url)
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.deleteAvatar(url: avatarUrls[indexPath.row]) { error in
            if error == nil {
                avatarUrls.remove(at: indexPath.row)
                getAvatars()
            } else {
                showAlert(error: error)
            }
        }
    }
}
