//
//  ReposViewModel.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import Foundation

// MARK: - Protocols
protocol ReposViewModelProtocol {
    func getRepos(page: Int, completion: @escaping ([String]?,Error?) -> Void)
}

// MARK: - ViewModel
class ReposViewModel: ReposViewModelProtocol {
    
    // MARK: - Variables
    var githubNetwork: GithubNetworkManagerProtocol
    
    // MARK: - Init and Deinit
    init() {
        githubNetwork = GithubNetworkManager.shared
        
        print("INIT - ReposViewModel")
    }
    
    deinit {
        print("DEINIT - ReposViewModel")
    }
    
    // MARK: - Functions
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
