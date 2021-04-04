//
//  AvatarViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit

class AvatarViewController: UIViewController, Storyboarded {
    
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
        viewModel?.getAvatarUrls(completion: { (urls) in
            self.avatarUrls = urls
            collectionView.reloadData()
        })
    }
}

extension AvatarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarUrls.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AvatarCell, !avatarUrls.isEmpty else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
        
        cell.setImageView(url: URL(string: avatarUrls[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.deleteAvatar(url: avatarUrls[indexPath.row])
        avatarUrls.remove(at: indexPath.row)
        getAvatars()
    }
}
