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

class EmojiViewController: UIViewController, Storyboarded {
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
        viewModel?.getEmojis(completion: { [weak self] (emoji, error) in
            guard let emoji = emoji else { return }
            let key = emoji.keys.randomElement()
            if let value = emoji.first(where: { $0.key == key })?.value {
                self?.setImage(url: value)
            } else {
                print(GithubError.notFound.localizedDescription)
            }
        })
    }
    
    @IBAction func searchUserButton(_ sender: UIButton) {
        viewModel?.getUser(login: searchBar.text ?? "", completion: { [weak self] (user, error) in
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

