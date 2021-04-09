//
//  AvatarViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import Foundation

// MARK: - Protocols
protocol AvatarViewModelProtocol {
    func getAvatarsUrl(completion: ([String]?, Error?) -> Void)
    func deleteAvatar(url: String, completion: (Error?) -> Void)
}

// MARK: - ViewModel
class AvatarViewModel: AvatarViewModelProtocol {
    
    // MARK: - Variables
    var coreData: EmojisCoreDataProtocol
    
    // MARK: - Init and Deinit
    init() {
        coreData = EmojisCoreData.shared
        
        print("INIT - AvatarViewModel")
    }
    
    deinit {
        print("DEINIT - AvatarViewModel")
    }
    
    // MARK: - Functions
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
