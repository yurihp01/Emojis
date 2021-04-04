//
//  EmojiListViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 03/04/21.
//

import UIKit
import RxSwift

class EmojiListViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var emoji: [String] = []
    
    var viewModel: EmojiListViewModelProtocol?
    weak var coordinator: EmojiListCoordinator?
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getEmojis()
        setCollectionView()
//        getObservable()
        // Do any additional setup after loading the view.
    }
    
//    private func getObservable() {
//        viewModel?.emoji.subscribe(onNext: { [weak self] (emoji) in
//            self?.emoji = emoji.map({ $0.value })
//            self?.collectionView.reloadData()
//        }, onError: { (error) in
//            print(error.localizedDescription)
//        }).disposed(by: DisposeBag())
//    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }
    
    private func getEmojis() {
        viewModel?.getEmojis(completion: { (emoji, error) in
            guard let emoji = emoji else { return }
            self.emoji = emoji.map({ $0.value })
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
        return emoji.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiListCell, !emoji.isEmpty else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
        
        cell.setImageView(url: URL(string: emoji[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        emoji.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}