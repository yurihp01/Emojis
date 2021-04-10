//
//  EmojiListViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit

final class EmojiListViewController: BaseViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    private let refreshControl = UIRefreshControl()
    
    var emoji: [String] = []
    var viewModel: EmojiListViewModelProtocol?
    weak var coordinator: EmojiListCoordinator?
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmojis()
        setViews()
    }
    
    // MARK: - Functions
    private func setViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        collectionView.accessibilityIdentifier = Constants.emojiList
        
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
                self?.showAlert(message: error?.localizedDescription)
            }
        })
    }
    
    @objc private func didPullToRefresh(_ sender: Any) {
        refreshControl.endRefreshing()
        getEmojis()
        collectionView.reloadData()
    }
}

// MARK: - Extensions
extension EmojiListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoji.isEmpty ? 0 : emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minSpace: CGFloat = 10
        let size = (collectionView.frame.size.width - minSpace) / 5
        return CGSize(width: size, height: size)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cell, for: indexPath) as? BaseCollectionViewCell, !emoji.isEmpty, let url = URL(string: emoji[indexPath.row]) {
            cell.initialize(url: url)
            cell.accessibilityIdentifier = Constants.cells
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cell, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        emoji.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}
