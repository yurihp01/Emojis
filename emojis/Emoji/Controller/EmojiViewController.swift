//
//  ViewController.swift
//  emojis
//
//  Created by Macbook on 31/03/21.
//

import UIKit
import RxSwift
import Kingfisher

class EmojiViewController: UIViewController, Storyboarded {
    @IBOutlet weak var emojiImage: UIImageView!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: EmojiViewModelProtocol?
    weak var coordinator: EmojiCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getObservable()
    }
    
    private func getObservable() {
        viewModel?.emoji.subscribe(
            onNext: { [weak self] emoji in
                let key = emoji.keys.randomElement()
                if let value = emoji.first(where: { $0.key == key })?.value {
                    let url = URL(string: value)
                    self?.emojiImage.kf.setImage(with: url)
                } else {
                    print(GithubError.notFound.localizedDescription)
                }
                
            }, onError: { error in
                print(error)
            }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func getEmojiButton(_ sender: UIButton) {
        viewModel?.getEmojis()
    }
}

