//
//  EmojiViewModelSpec.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 07/04/21.
//

import Nimble
import Quick
@testable import emojis

class EmojiViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("EmojiViewModel") {
            
            var sut: EmojiViewModel!
            
            beforeEach {
                sut = EmojiViewModel()
                sut.coreData = MockCoreData(status: .success)
                sut.githubManager = GithubNetworkManagerMock(status: .success)
            }
            
            afterEach {
                sut = nil
            }
            
            context("Get Emojis") {
                
                it("Get Emojis") {
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).toNot(beNil())
                        expect(emoji?.first?.key).to(equal("Emoji"))
                    }
                }
                
                it("Get Emojis With Internet Connection Error") {
                    sut.githubManager = GithubNetworkManagerMock(status: .internetConnection)
                    
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(GithubError.internetConnection.errorDescription))
                    }
                }
                
                it("Get Emojis With JSON Mapping Error") {
                    sut.githubManager = GithubNetworkManagerMock(status: .jsonMapping)
                    
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(GithubError.jsonMapping.errorDescription))
                    }
                }
                
                it("Get Emojis With Not Found Error") {
                    sut.githubManager = GithubNetworkManagerMock(status: .notFound(name: "Emojis"))
                    
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(GithubError.notFound(name: "Emojis").errorDescription))
                    }
                }
                
                it("Get Emojis From CoreData") {
                    try sut.coreData.saveEmoji(name: "Emoji", link: "emoji.com")
                    
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).toNot(beNil())
                        expect(emoji?.first?.key).to(equal("Emoji"))
                        expect(emoji?.first?.value).to(equal("emoji.com"))
                    }
                }
      
                
                it("Get Emojis With Retrieve Error From CoreData") {
                    sut.coreData = MockCoreData(status: .retrieveError)
                    
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(CoreDataError.retrieve.errorDescription))
                    }
                }
            }
            
            context("Get Avatar") {
                
                it("Get Avatar") {
                    sut.getAvatar(login: "avatar") { (avatar, error) in
                        expect(error).to(beNil())
                        expect(avatar).toNot(beNil())
                        expect(avatar?.avatarUrl).to(equal("Avatar"))
                    }
                }
                
                it("Get Avatar With Not Found Error") {
                    sut.githubManager = GithubNetworkManagerMock(status: .notFound(name: "Avatar"))
                    
                    sut.getAvatar(login: "avatar") { (avatar, error) in
                        expect(avatar).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal("Avatar not found. Contact with your app administrator."))
                    }
                }
                
                it("Get Avatar With Internet Connection Error") {
                    sut.githubManager = GithubNetworkManagerMock(status: .internetConnection)
                    
                    sut.getAvatar(login: "avatar") { (avatar, error) in
                        expect(avatar).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal("The internet connection appears to be offline. Check your connection and try again."))
                    }
                }
                
                it("Get Avatar With JSON Mapping Error") {
                    sut.githubManager = GithubNetworkManagerMock(status: .jsonMapping)
                    
                  sut.getAvatar(login: "avatar") { (avatar, error) in
                        expect(avatar).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal("Failed to map data to JSON object. Contact with your app administrator."))
                    }
                }
                
                it("Get Avatar From CoreData") {
                    try sut.coreData.saveAvatar(login: "Avatar", url: "avatar.com", id: 1)
                    
                    let avatar = try sut.coreData.retrieveAvatar(login: "Avatar")
                    
                    expect(avatar).toNot(beNil())
                }
                
                it("Get Avatar With Retrieve Error From CoreData") {
                    sut.coreData = MockCoreData(status: .retrieveError)
                    
                    sut.getAvatar(login: "Avatar") { (avatar, error) in
                        expect(avatar).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(CoreDataError.retrieve.localizedDescription))
                    }
                }
            }
        }
    }
    
}
