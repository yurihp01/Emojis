//
//  AvatarViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import UIKit

protocol AvatarViewModelProtocol {
    func getAvatarsUrl(completion: ([String]?, Error?) -> Void)
    func deleteAvatar(url: String, completion: (Error?) -> Void)
}

class AvatarViewModel: AvatarViewModelProtocol {

    var coreData: EmojisCoreDataProtocol
    
    init() {
        coreData = EmojisCoreData.shared
        
        print("INIT - AvatarViewModel")
    }
    
    deinit {
        print("DEINIT - AvatarViewModel")
    }
    
    func getAvatarsUrl(completion: ([String]?, Error?) -> Void) {
        do {
            let urls = try coreData.retrieveAvatarsUrl()
            completion(urls, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func deleteAvatar(url: String, completion: (Error?) -> Void) {
        do {
            try coreData.deleteAvatar(url: url)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
