//
//  EmojiListViewControllerSpec.swift
//  emojisTests
//
//  Created by Yuri Pedroso on 06/04/21.
//
//
//

import Quick
import Nimble
@testable import emojis

class EmojiListViewModelMock: EmojiListViewModelProtocol {
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        completion(["a":"a", "b":"b", "c":"c", "d":"d", "e":"e", "f":"f"], nil)
    }
}

class EmojiListViewModelMockError: EmojiListViewModelProtocol {
    func getEmojis(completion: @escaping (EmojiType?, Error?) -> Void) {
        completion(nil, GithubError.jsonMapping)
    }
}

class EmojiListViewControllerSpec: QuickSpec {

    override func spec() {
        describe("EmojiListViewController") {
            var sut: EmojiListViewController!
            var sutMock: EmojiListViewModelProtocol!
            var sutMockWithError: EmojiListViewModelProtocol!
            var indexPath: IndexPath!
            var cell: UICollectionViewCell!
            
            beforeEach {
                sut = EmojiListViewController.instantiate(storyboardName: "EmojiList")
            }
            
            afterEach {
                sut = nil
            }
            
            context("EmojiListViewController") {
                beforeEach {
                    sutMock = EmojiListViewModelMock()
                    sut.viewModel = sutMock
                    sut.viewDidLoad()
                    indexPath = IndexPath(row: 0, section: 0)
                    cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath)
                }
                
                it("Get Emojis") {
                    sutMock.getEmojis { (emoji, error) in
                        if let emoji = emoji {
                            sut.emoji = emoji.map({ $0.value })
                            expect(emoji).toNot(beNil())
                            
                            sut.collectionView.reloadData()
                            
                            expect(sut.emoji.count).to(equal(6))
                            expect(sut.collectionView.dataSource).toNot(beNil())
                            expect(cell).to(beAKindOf(BaseCollectionViewCell.self))
                        }
                    }
                }
                
                it("Delete Avatar") {
                    sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: indexPath)
                    expect(sut.emoji.count).to(equal(5))
                }
                
                it("Pull To Refresh") {
                    sut.didPullToRefresh(UIRefreshControl())
                    expect(sut.refreshControl.isRefreshing).to(beFalse())
                    expect(sut.emoji.count).to(equal(6))
                }
            }
            
            context("AvatarViewController With Errors") {
                beforeEach {
                    sutMockWithError = EmojiListViewModelMockError()
                    sut.viewModel = sutMockWithError
                    sut.viewDidLoad()
                    indexPath = IndexPath(row: 0, section: 0)
                    cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath)
                }

                it("Get Avatars With Error") {
                    sutMockWithError.getEmojis { (emoji, error) in
                        sut.showAlert(error: error)
                    expect(error?.localizedDescription).to(equal("Failed to map data to JSON object. Contact with your app administrator."))
                    }
                }
                
                it("Check if hasn't cell") {
                    let indexPath = IndexPath(row: 0, section: 0)
                    let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath)
                    expect(cell).toNot(beAKindOf(Avatar.self))
                }
            }
        }
    }
}
