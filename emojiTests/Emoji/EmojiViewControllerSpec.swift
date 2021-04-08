//
//  EmojiViewControllerSpec.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 07/04/21.
//

import Nimble
import Quick
@testable import emojis

class EmojiViewModelMock: EmojiViewModelProtocol  {
    
    enum Status {
        case error
        case success
    }
    
    var status: Status
    
    init(status: Status) {
        self.status = status
    }
    
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        switch status {
        case .error:
            completion(nil, GithubError.jsonMapping)
        case .success:
            completion(["emoji1":"emoji1", "emoji2":"emoji2"], nil)
        }
    }
    
    func getAvatar(login: String, completion: @escaping (Avatar?, Error?) -> Void) {
        switch status {
        case .error:
            completion(nil, GithubError.jsonMapping)
        case .success:
            completion(Avatar(login: login, avatarUrl: login, id: 1), nil)
        }
    }
}

class EmojiViewControllerSpec: QuickSpec {

    override func spec() {
        describe("EmojiViewController") {
            
            var sut: EmojiViewController!
            var sutMock: EmojiViewModelMock!
            
            beforeEach {
                sutMock = EmojiViewModelMock(status: .success)
                sut = EmojiViewController.instantiate(storyboardName: "Emoji")
                sut.viewModel = sutMock
                sut.viewDidLoad()
            }
            
            afterEach {
                sut = nil
            }
            
            context("Get Random Image") {
                it("Get Random Image") {
                    expect(sut.emojiImage.image).to(beNil())
                    
                    sut.getRandomImage()
                    
                    // if Kingfisher downloads the image, it shows a random image
                    expect(sut.emojiImage.image).toEventuallyNot(beNil())
                }
                
                it("Get Random Image With Error") {
                    sut.viewModel = EmojiViewModelMock(status: .error)

                    expect(sut.emojiImage.image).to(beNil())
                    
                    sut.getRandomImage()
                    
                    // If Kingfisher cannot download the image, it shows the .remove icon
                    expect(sut.emojiImage.image).toEventually(equal(.remove))
                }
            }
            
            context("Set Image View Function With Error") {
                
                // I tested only with error because the success case exists on Get random image test
                it("Nil URL") {
                    sut.setImageView(url: nil)
                    expect(sut.emojiImage.image).to(beNil())
                }
            }
            
            context("Search Button") {
                it("Search Button Pressed") {
                    sut.searchBar.text = "blissapps"
                    expect(sut.searchBar.text).toNot(beEmpty())
                    
                    sut.searchUserButton(UIButton())
                    expect(sut.searchBar.text).to(beEmpty())
                    
                    // URL to kf is not correct, so the image should be nil
                    expect(sut.emojiImage.image).to(beNil())
                    
                    expect(sut.searchBar.isFirstResponder).to(beFalse())
                }
            }
        }
    }

}
