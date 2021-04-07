//
//  AvatarViewModelSpec.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 05/04/21.
//

import Nimble
import Quick
@testable import emojis

class AvatarViewModelSpec: QuickSpec {
    override func spec() {
        describe("AvatarViewModel") {
            
            var sut: AvatarViewModel!
            
            beforeEach {
                sut = AvatarViewModel()
            }
            
            afterEach {
                sut = nil
            }
            
            context("GetAvatarUrls") {
                it("Get avatars Url") {
                    sut.coreData = MockCoreData()
                    
                    try sut.coreData.saveAvatar(login: "avatar", url: "avatar.com", id: 1)
                    
                    sut.getAvatarsUrl { (urls, error) in
                        expect(error).to(beNil())
                        expect(urls).toNot(beNil())
                        expect(urls?.count).to(beGreaterThan(0))
                        expect(urls?.first).to(equal("avatar.com"))
                    }
                    try sut.coreData.saveAvatar(login: "avatar", url: "avatar.com", id: 1)

                }
                
                it("Get avatars Error") {
                    sut.coreData = MockCoreDataError()

                    sut.getAvatarsUrl { (urls, error) in
                        expect(urls).to(beNil())
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(CoreDataError.retrieve.localizedDescription))
                        }
                }
            }
            
            context("GetAvatarUrls") {
                it("Delete avatars") {
                    sut.coreData = MockCoreData()

                    try sut.coreData.saveAvatar(login: "avatar", url: "avatar.com", id: 1)
                    sut.deleteAvatar(url: "avatar.com", completion: { (error) in
                        expect(error).to(beNil())
                        expect(try? sut.coreData.retrieveAvatarsUrl().count).to(equal(0))
                    })
                }
                
                it("Delete avatars Error") {
                    sut.coreData = MockCoreDataError()

                    sut.deleteAvatar(url: "avatar.com", completion: { (error) in
                        expect(error).toNot(beNil())
                        expect(error?.localizedDescription).to(equal(CoreDataError.delete.localizedDescription))
                    })
                }
            }
        }
    }
}
