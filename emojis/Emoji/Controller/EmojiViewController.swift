//
//  ViewController.swift
//  emojis
//
//  Created by Macbook on 31/03/21.
//

import UIKit
import RxSwift

class EmojiViewController: UIViewController, Storyboarded {
    let disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: EmojiViewModelProtocol?
    weak var coordinator: EmojiCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getObservable()
    }
    
    private func getObservable() {
        viewModel?.emoji.subscribe(
            onNext: { emoji in
                print(emoji)
            }, onError: { error in
                print(error)
            }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func getEmojiButton(_ sender: UIButton) {
        viewModel?.getEmojis()
    }
}

