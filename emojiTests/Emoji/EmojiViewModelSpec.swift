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
                sut.coreData = MockCoreData()
                sut.githubManager = MockNetworkManager()
            }
            
            afterEach {
                sut = nil
            }
            
            context("Get Emojis") {

                it("Get Emojis") {
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).toNot(beNil())
                        expect(emoji?.first?.key).to(equal("smile"))
                        expect(emoji?.first?.value).to(equal("smile.com"))
                    }
                }
                
                it("Get Emojis With Error") {
                    sut.githubManager = MockNetworkManagerError()

                    sut.getEmojis { (emoji, error) in
                        expect(emoji).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal("Emojis not found. Contact with your app administrator."))
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
                
                it("Get Emojis With Error From CoreData") {
                    sut.coreData = MockCoreDataError()

                    expect(try sut.coreData.saveEmoji(name: "Emoji", link: "emoji.com")).to(throwError(CoreDataError.save))
                    
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal("An error occurred while retrieving data. Check with your app administrator and try again."))
                    }
                }
            }
            
            context("Get Avatar") {
                
                it("Get Avatar") {
                    sut.getAvatar(login: "apple") { (avatar, error) in
                        expect(error).to(beNil())
                        expect(avatar).toNot(beNil())
                        expect(avatar?.avatarUrl).to(equal("avatar.com"))
                    }
                }
                
                it("Get Avatar With Error") {
                    sut.githubManager = MockNetworkManagerError()

                    sut.getAvatar(login: "avatar") { (avatar, error) in
                        expect(avatar).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal("Avatar not found. Contact with your app administrator."))
                    }
                }
                
                it("Get Avatar From CoreData") {
                    try sut.coreData.saveAvatar(login: "Avatar", url: "avatar.com", id: 1)
                    
                    let avatar = try sut.coreData.retrieveAvatar(login: "Avatar")
                    
                    expect(avatar).toNot(beNil())
                }
                
                it("Get Avatar With Error From CoreData") {
                    sut.coreData = MockCoreDataError()

                    expect(try sut.coreData.saveEmoji(name: "Emoji", link: "emoji.com")).to(throwError(CoreDataError.save))
                    
                    sut.getAvatar(login: "Avatar") { (avatar, error) in
                        expect(avatar).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal("An error occurred while retrieving data. Check with your app administrator and try again."))
                    }
                }
            }
        }
    }
    
}
