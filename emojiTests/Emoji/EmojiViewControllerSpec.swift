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
    var hasIndicatorStartAnimation = false
    
    init(status: Status) {
        self.status = status
    }
    
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        switch status {
        case .error:
            completion(nil, GithubError.jsonMapping)
        case .success:
            completion(["emoji1":"https://github.githubassets.com/images/icons/emoji/unicode/1f44e.png?v8", "emoji2":"https://github.githubassets.com/images/icons/emoji/unicode/1f44e.png?v8"], nil)
        }
    }
    
    func getAvatar(login: String, completion: @escaping (Avatar?, Error?) -> Void) {
        hasIndicatorStartAnimation = true

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
            var sutModel: EmojiViewModelMock!
          
            beforeEach {
                sut = EmojiViewController.instantiate(storyboardName: .emoji)
                sutModel = EmojiViewModelMock(status: .success)
                sut.viewModel = sutModel
                sut.viewDidLoad()
            }
          
            afterEach {
              sut = nil
              sutModel = nil
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

                    sut.emojiImage.image = nil
                    
                    sut.getRandomImage()
                    
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
                
                it("Search Text Is Empty") {
                    sut.searchBar.text = ""
                    
                    expect(sut.searchBar.text).to(beEmpty())
                    expect(sutModel.hasIndicatorStartAnimation).to(beFalse())
                    
                    sut.searchUserButton(UIButton())
                    
                    // Indicator just updates if search button is not empty
                    expect(sutModel.hasIndicatorStartAnimation).to(beFalse())
                }
              
                it("Search Button Shows Indicator") {
                    sut.searchBar.text = "blissapps"
                    expect(sutModel.hasIndicatorStartAnimation).to(beFalse())
                    
                    sut.searchUserButton(UIButton())
                  
                }
            }
        }
    }

}
