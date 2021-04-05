//
//  EmojiListViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit

final class EmojiListViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var emoji: [String] = []
    
    var viewModel: EmojiListViewModelProtocol?
    weak var coordinator: EmojiListCoordinator?
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmojis()
        setViews()
    }
    
    private func setViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
    }
    
    private func getEmojis() {
        indicator.startAnimating()
        
        viewModel?.getEmojis(completion: { [weak self] (emoji, error) in
            self?.indicator.stopAnimating()
            if let emoji = emoji {
                self?.emoji = emoji.map({ $0.value })
                self?.collectionView.reloadData()
            } else {
                self?.showAlert(error: error)
            }
        })
    }
    
    @objc func didPullToRefresh(_ sender: Any) {
        refreshControl.endRefreshing()
        getEmojis()
        collectionView.reloadData()
    }
}

extension EmojiListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoji.isEmpty ? 0 : emoji.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BaseCollectionViewCell, !emoji.isEmpty, let url = URL(string: emoji[indexPath.row]) {
            cell.initialize(url: url)
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        emoji.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}
