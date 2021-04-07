//
//  EmojiListViewModelSpec.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 06/04/21.
//

import Nimble
import Quick
@testable import emojis

class EmojiListViewModelSpec: QuickSpec {
    override func spec() {
        describe("EmojiListViewModel") {
            
            var sut: EmojiListViewModel!
            
            beforeEach {
                sut = EmojiListViewModel()
                sut.coreData = MockCoreData()
            }
            
            afterEach {
                sut = nil
            }
            
            context("Get Emojis") {
                
                beforeEach {
                    sut.networkManager = MockNetworkManager()
                }
                
                it("Get Emojis") {
                    sut.getEmojis { (emoji, error) in
                        expect(emoji).toNot(beNil())
                        expect(emoji?.first?.key).to(equal("smile"))
                        expect(emoji?.first?.value).to(equal("smile.com"))
                    }
                }
                
                it("Get Emojis With Error") {
                    sut.networkManager = MockNetworkManagerError()

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
        }
    }

}
