//
//  ReposViewControllerSpec.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 06/04/21.
//

import Quick
import Nimble
@testable import emojis

// MARK: - Mock
class ReposMockViewModel: ReposViewModelProtocol {
    func getRepos(page: Int, completion: @escaping ([String]?, Error?) -> Void) {
        page == 1 ? completion(["Apple 1", "Apple 2"], nil) : completion(nil, GithubError.notFound(name: "Repos"))
    }
}

// MARK: - Tests - ReposViewControllerSpec
class ReposViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ReposViewController") {
            
            var sut: ReposViewController!
            
            beforeEach {
                sut = ReposViewController.instantiate(storyboardName: .repos)
                sut.viewDidLoad()
                sut.viewModel = ReposMockViewModel()
            }
            
            afterEach {
                sut = nil
            }
            
            context("Get Repos") {
                it("Get Repos Function") {
                    expect(sut.repos.count).to(equal(0))
                    expect(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)).to(equal(0))
                    
                    sut.getRepos()
                    
                    expect(sut.repos.count).to(equal(2))
                    expect(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)).to(equal(10))
                }
                
                it("Get Repos Error") {
                    expect(sut.repos.count).to(equal(0))
                    expect(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)).to(equal(0))
                    
                    // it will makes the getRepos returns error
                    sut.currentPage = 2
                    
                    sut.getRepos()
                    
                    expect(sut.repos.count).to(equal(0))
                    expect(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)).to(equal(0))
                }
            }
        }
    }
    
}
