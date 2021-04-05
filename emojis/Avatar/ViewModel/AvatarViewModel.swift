//
//  AvatarViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import UIKit

protocol AvatarViewModelProtocol {
    func getAvatarUrls(completion: ([String]?, Error?) -> Void)
    func deleteAvatar(url: String, completion: (Error?) -> Void)
}

class AvatarViewModel: AvatarViewModelProtocol {

    init() {
        print("INIT - AvatarViewModel")
    }
    
    deinit {
        print("DEINIT - AvatarViewModel")
    }
    
    func getAvatarUrls(completion: ([String]?, Error?) -> Void) {
        do {
            let urls = try EmojisCoreData.shared.retrieveAvatarsUrl()
            completion(urls, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func deleteAvatar(url: String, completion: (Error?) -> Void) {
        do {
            try EmojisCoreData.shared.deleteAvatar(url: url)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
