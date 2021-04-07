//
//  MockNetworkManager.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 06/04/21.
//

import Nimble
import Quick
import Moya
@testable import emojis

class MockNetworkManagerError: GithubNetworkManagerProtocol {
    func getAvatarByUsername(username: String, completion: @escaping (Avatar?, Error?) -> Void) {
        completion(nil, GithubError.notFound(name: "Avatar"))
    }
    
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        completion(nil, GithubError.notFound(name: "Emojis"))
    }
    
    func getRepos(page: Int, completion: @escaping ([Repo]?, Error?) -> Void) {
        completion(nil, GithubError.notFound(name: "Repos"))
    }
}

class MockNetworkManager: QuickSpec {
    override func spec() {
        describe("MockNetworkManager") {
            
            var provider: MoyaProvider<GithubService>!
            var sut: GithubNetworkManager!
            
            beforeEach {
                sut = GithubNetworkManager.shared
                provider = MoyaProvider<GithubService>(stubClosure: MoyaProvider.immediatelyStub)
                sut.provider = provider
            }
            
            context("Get Emojis") {
                it("Get Emojis") {
                    sut.getEmojis(completion: { (emoji, error) in
                        expect(emoji).toNot(beNil())
                        expect(emoji?.first?.key).to(equal("image"))
                        expect(emoji?.first?.value).to(equal("image.com"))
                    })
                }
            }
            
            context("Get Avatar By Username") {
                it("Get Avatar By Username") {
                    sut.getAvatarByUsername(username: "yuri") { (avatar, error) in
                        expect(avatar).toNot(beNil())
                        expect(avatar?.avatarUrl).to(equal("yuri.com"))
                        expect(avatar?.id).to(equal(1))
                        expect(avatar?.login).to(equal("Yuri"))
                    }
                }
            }
            
            context("Get Avatar By Username") {
                it("Get Avatar By Username") {
                    sut.getRepos(page: 1, completion: { (repo, error) in
                        if let repo = repo {
                            expect(repo).toNot(beNil())
                            expect(repo.first?.fullName).to(equal("Apple"))
                            expect(repo.first?.id).to(equal(0))
                            expect(repo.first?.privateRep).to(beTrue())
                        }
                    })
                }
            }
        }
    }
    
}

extension MockNetworkManager: GithubNetworkManagerProtocol {
    func getAvatarByUsername(username: String, completion: @escaping (Avatar?, Error?) -> Void) {
        completion(Avatar(login: "Avatar", avatarUrl: "avatar.com", id: 1), nil)
    }
    
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        completion(["smile":"smile.com"], nil)
    }
    
    func getRepos(page: Int, completion: @escaping ([Repo]?, Error?) -> Void) {
        completion([Repo(id: 1, fullName: "Apple", privateRep: true)], nil)
    }
}
