//
//  ViewController.swift
//  emojis
//
//  Created by Macbook on 31/03/21.
//

import UIKit
import Kingfisher

// MARK: - Protocols
protocol EmojiProtocol: class {
    func emojisList()
    func avatarsList()
}

// MARK: - Class
final class EmojiViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    weak var coordinator: EmojiCoordinator?
    var viewModel: EmojiViewModelProtocol?
    var emoji: [String] = []
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBarAndIndicator()
        getRandomImage()
    }
    
    // MARK: - Functions
    private func setSearchBarAndIndicator() {
        searchBar.autocapitalizationType = .none
        searchBar.accessibilityTraits = UIAccessibilityTraits.searchField
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        
        if let textfield = searchBar.value(forKey: Constants.searchField) as? UITextField {
            textfield.backgroundColor = .white
        }
        
        indicator.color = .white
    }
    
    func getRandomImage() {
        indicator.startAnimating()
        viewModel?.getEmojis(completion: { [weak self] (emoji, error) in
            self?.indicator.stopAnimating()
            
            if let emoji = emoji {
                let key = emoji.keys.randomElement()
                if let value = emoji.first(where: { $0.key == key })?.value, let url = URL(string: value) {
                    self?.emojiImage.setImageView(url: url)
                } else {
                    self?.showAlert(message: error?.localizedDescription)
                }
            } else {
                self?.showAlert(message: error?.localizedDescription)
            }
        })
    }
    
    private func getAvatar(text: String) {
        viewModel?.getAvatar(login: text, completion: { [weak self] (user, error) in
            self?.indicator.stopAnimating()
            self?.searchBar.text = ""
            self?.searchBar.resignFirstResponder()
            
            if let user = user, let url = user.url {
                self?.emojiImage.kf.setImage(with: url)
            } else {
                self?.showAlert(message: error?.localizedDescription)
            }
        })
    }
    
    // MARK: - IBActions
    @IBAction func emojiListButton(_ sender: UIButton) {
        coordinator?.emojisList()
    }
    
    @IBAction func randomEmojiButton(_ sender: UIButton) {
        getRandomImage()
    }
    
    @IBAction func searchUserButton(_ sender: UIButton) {
        if let text = searchBar.text, !text.isEmpty {
            indicator.startAnimating()
            getAvatar(text: text)
        } else {
            showAlert(message: Constants.searchFieldError)
        }
    }
    
    @IBAction func avatarsListButton(_ sender: UIButton) {
        coordinator?.avatarsList()
    }
    
    @IBAction func appleRepositories(_ sender: UIButton) {
        coordinator?.reposList()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Extensions
extension EmojiViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
