//
//  ReposViewModelSpec.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 06/04/21.
//

import Nimble
import Quick
@testable import emojis

class ReposViewModelSpec: QuickSpec {
    override func spec() {
        describe("ReposViewModel") {
            
            var sut: ReposViewModel!
            var networkMock: GithubNetworkManagerProtocol!

            beforeEach {
                sut = ReposViewModel()
                networkMock = MockNetworkManager()
                sut.githubNetwork = networkMock
            }
            
            context("Get Repos") {
                it("Get Repos") {
                    sut.getRepos(page: 2) { (repos, error) in
                        expect(error).to(beNil())
                        expect(repos).toNot(beNil())
                        expect(repos?.first).to(equal("Apple"))
                    }
                }
                
                it("Get Repos With Error") {
                    networkMock = MockNetworkManagerError()
                    sut.githubNetwork = networkMock

                    sut.getRepos(page: 1) { (repos, error) in
                        expect(error).toNot(beNil())
                        expect(repos).to(beNil())
                        expect(error?.localizedDescription).to(equal("Repos not found. Contact with your app administrator."))
                    }
                }
            }
        }
    }
}
