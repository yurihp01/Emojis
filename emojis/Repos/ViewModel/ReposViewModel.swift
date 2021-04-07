//
//  ReposViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import Foundation

protocol ReposViewModelProtocol {
    func getRepos(page: Int, completion: @escaping ([String]?,Error?) -> Void)
}

class ReposViewModel: ReposViewModelProtocol {
    var githubNetwork: GithubNetworkManagerProtocol
    
    init() {
        print("INIT - ReposViewModel")
        githubNetwork = GithubNetworkManager.shared
    }
    
    deinit {
        print("DEINIT - ReposViewModel")
    }
    
    func getRepos(page: Int, completion: @escaping ([String]?, Error?) -> Void) {
        githubNetwork.getRepos(page: page) { (repos, error) in
            if let repos = repos {
                let names = repos.compactMap { (repo) -> String in
                    repo.fullName
                }
                completion(names, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
