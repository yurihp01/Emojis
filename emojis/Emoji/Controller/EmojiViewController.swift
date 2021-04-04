//
//  ViewController.swift
//  emojis
//
//  Created by Macbook on 31/03/21.
//

import UIKit
import RxSwift
import Kingfisher

protocol EmojiProtocol: class {
    func emojisList()
    func avatarsList()
}

class EmojiViewController: UIViewController, Storyboarded {
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    weak var coordinator: EmojiCoordinator?
    var viewModel: EmojiViewModelProtocol?
    var emoji: EmojiType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getObservable()
        setSearchBar()
    }
    
    private func setSearchBar() {
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.backgroundColor = .white
        
    }
    
    private func getObservable() {
        viewModel?.emoji.subscribe(
            onNext: { [weak self] emoji in
                
            let key = emoji.keys.randomElement()
            if let value = emoji.first(where: { $0.key == key })?.value {
                self?.setImage(url: value)
            } else {
                print(GithubError.notFound.localizedDescription)
            }
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    private func setImage(url: String) {
        let url = URL(string: url)
        emojiImage.kf.setImage(with: url)
    }
    
    @IBAction func emojiListButton(_ sender: UIButton) {
        coordinator?.emojisList()
    }
    
    @IBAction func randomEmojiButton(_ sender: UIButton) {
        viewModel?.getEmojis()
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

