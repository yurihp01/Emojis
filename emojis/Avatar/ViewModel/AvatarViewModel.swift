//
//  AvatarViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import UIKit

protocol AvatarViewModelProtocol {
    func getAvatarUrls(completion: ([String]) -> Void)
    func deleteAvatar(url: String)
}

class AvatarViewModel: AvatarViewModelProtocol {

    init() {
        print("INIT - AvatarViewModel")
    }
    
    deinit {
        print("DEINIT - AvatarViewModel")
    }
    
    func getAvatarUrls(completion: ([String]) -> Void) {
        let urls = CoreData.shared.retrieveAvatarsUrl()
        completion(urls)
    }
    
    func deleteAvatar(url: String) {
        CoreData.shared.deleteAvatar(url: url)
    }
}
