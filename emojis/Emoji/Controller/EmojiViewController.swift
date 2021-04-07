//
//  ViewController.swift
//  emojis
//
//  Created by Macbook on 31/03/21.
//

import UIKit
import Kingfisher

protocol EmojiProtocol: class {
    func emojisList()
    func avatarsList()
}

final class EmojiViewController: BaseViewController {
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var coordinator: EmojiCoordinator?
    var viewModel: EmojiViewModelProtocol?
    var emoji: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBarAndIndicator()
        getRandomImage()
    }
    
    private func setSearchBarAndIndicator() {
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.backgroundColor = .white
        indicator.color = .black
    }
    
    private func getRandomImage() {
        indicator.startAnimating()
        viewModel?.getEmojis(completion: { [weak self] (emoji, error) in
            self?.indicator.stopAnimating()
            
            if let emoji = emoji {
                let key = emoji.keys.randomElement()
                if let value = emoji.first(where: { $0.key == key })?.value {
                    self?.setImageView(url: URL(string: value))
                } else {
                    self?.showAlert(error: error)
                }
            } else {
                self?.showAlert(error: error)
            }
        })
    }

    private func setImageView(url: URL?) {
        guard let url = url else { print("URL not found"); return }
        emojiImage.kf.indicatorType = .activity
        emojiImage.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage, .fromMemoryCacheOrRefresh, .onFailureImage(.remove)])
    }
    
    @IBAction func emojiListButton(_ sender: UIButton) {
        coordinator?.emojisList()
    }
    
    @IBAction func randomEmojiButton(_ sender: UIButton) {
        getRandomImage()
    }
    
    @IBAction func searchUserButton(_ sender: UIButton) {
        indicator.startAnimating()
        viewModel?.getAvatar(login: searchBar.text ?? "", completion: { [weak self] (user, error) in
            self?.indicator.stopAnimating()
            self?.searchBar.text = ""
            self?.searchBar.resignFirstResponder()
            
            if let user = user {
                guard let url = user.url else { return }
                self?.emojiImage.kf.setImage(with: url)
            } else {
                self?.showAlert(error: error)
            }
        })
    }
    
    @IBAction func avatarsListButton(_ sender: UIButton) {
        coordinator?.avatarsList()
    }
    
    @IBAction func appleRepositories(_ sender: UIButton) {
        coordinator?.reposList()
    }
}

