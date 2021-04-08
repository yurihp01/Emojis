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

            beforeEach {
                sut = ReposViewModel()
                sut.githubNetwork = GithubNetworkManagerMock(status: .success)
            }
            
            context("Get Repos") {
                it("Get Repos") {
                    sut.getRepos(page: 2) { (repos, error) in
                        expect(error).to(beNil())
                        expect(repos).toNot(beNil())
                        expect(repos?.first).to(equal("Repo"))
                    }
                }
                
                it("Get Repos With Internet Connection Error") {
                    sut.githubNetwork = GithubNetworkManagerMock(status: .internetConnection)

                    sut.getRepos(page: 2) { (repos, error) in
                        expect(repos).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(GithubError.internetConnection.errorDescription))
                    }
                }
                
                it("Get Repos With JSON Mapping Error") {
                    sut.githubNetwork = GithubNetworkManagerMock(status: .jsonMapping)

                    sut.getRepos(page: 2) { (repos, error) in
                        expect(repos).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(GithubError.jsonMapping.errorDescription))
                    }
                }
                
                it("Get Repos With Not Found Error") {
                    sut.githubNetwork = GithubNetworkManagerMock(status: .notFound(name: "Repos"))

                    sut.getRepos(page: 2) { (repos, error) in
                        expect(repos).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(GithubError.notFound(name: "Repos").errorDescription))
                    }
                }
            }
        }
    }
}
