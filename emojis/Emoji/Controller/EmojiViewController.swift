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
        setSearchBar()
    }
    
    private func setSearchBar() {
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.backgroundColor = .white
    }
    
    private func setImage(url: String) {
        let url = URL(string: url)
        emojiImage.kf.setImage(with: url)
    }
    
    @IBAction func emojiListButton(_ sender: UIButton) {
        coordinator?.emojisList()
    }
    
    @IBAction func randomEmojiButton(_ sender: UIButton) {
        indicator.startAnimating()
        viewModel?.getEmojis(completion: { [weak self] (emoji, error) in
            self?.indicator.stopAnimating()
            
            if let emoji = emoji {
                let key = emoji.keys.randomElement()
                if let value = emoji.first(where: { $0.key == key })?.value {
                    self?.setImage(url: value)
                } else {
                    print(GithubError.notFound.localizedDescription)
                }
            } else {
                print(GithubError.notFound.localizedDescription)
            }
        })
    }
    
    @IBAction func searchUserButton(_ sender: UIButton) {
        indicator.startAnimating()
        viewModel?.getUser(login: searchBar.text ?? "", completion: { [weak self] (user, error) in
            self?.indicator.stopAnimating()
            self?.searchBar.text = ""
            self?.searchBar.resignFirstResponder()
            
            if let user = user {
                guard let url = user.url else { return }
                self?.emojiImage.kf.setImage(with: url)
            } else {
                print("Error: User not found")
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

