//
//  AvatarViewControllerSpec.swift
//  emojisTests
//
//  Created by Yuri Pedroso on 05/04/21.
//
//
//

import Quick
import Nimble
@testable import emojis

class AvatarViewModelMock: AvatarViewModelProtocol {
    func getAvatarsUrl(completion: ([String]?, Error?) -> Void) {
        
        completion(["A", "B", "C"], nil)
    }

    func deleteAvatar(url: String, completion: (Error?) -> Void) {
        completion(nil)
    }
}

class AvatarViewModelMockError: AvatarViewModelProtocol {
    func getAvatarsUrl(completion: ([String]?, Error?) -> Void) {
        
        completion(nil, GithubError.notFound(name: "Avatar"))
    }

    func deleteAvatar(url: String, completion: (Error?) -> Void) {
        completion(CoreDataError.delete)
    }
}

class AvatarViewControllerSpec: QuickSpec {

    override func spec() {
        describe("AvatarViewController") {
            var sut: AvatarViewController!
            var sutMock: AvatarViewModelMock!
            var sutMockWithError: AvatarViewModelMockError!
            var indexPath: IndexPath!
            var cell: UICollectionViewCell!
            
            beforeEach {
                sut = AvatarViewController.instantiate(storyboardName: "Avatar")
            }
            
            afterEach {
                sut = nil
            }
            
            context("AvatarViewController Without Errors") {
                beforeEach {
                    sutMock = AvatarViewModelMock()
                    sut.viewModel = sutMock
                    sut.viewDidLoad()
                    indexPath = IndexPath(row: 0, section: 0)
                    cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath)
                }
                
                it("Get Avatars") {
                    sutMock.getAvatarsUrl { (urls, error) in
                        if let urls = urls {
                            sut.avatarUrls = urls
                            sut.collectionView.reloadData()
                            expect(sut.avatarUrls.count).to(equal(3))
                            expect(sut.collectionView.dataSource).toNot(beNil())
                            expect(cell).to(beAKindOf(BaseCollectionViewCell.self))
                            
                        }
                    }
                }
                
                it("Delete Avatar") {
                    sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: indexPath)
                }
            }
            
            context("AvatarViewController With Errors") {
                beforeEach {
                    sutMockWithError = AvatarViewModelMockError()
                    sut.viewModel = sutMockWithError
                    sut.viewDidLoad()
                    indexPath = IndexPath(row: 0, section: 0)
                    cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath)
                }

                it("Get Avatars With Error") {
                    sut.viewModel = sutMockWithError
                    sutMockWithError.getAvatarsUrl { (urls, error) in
                        if let error = error {
                            sut.showAlert(error: error)
                            expect(error.localizedDescription).to(equal("Avatar not found. Contact with your app administrator."))
                        }
                    }
                }
                
                it("Check if hasn't cell") {
                    let indexPath = IndexPath(row: 0, section: 0)
                    let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath)
                    expect(cell).toNot(beAKindOf(Avatar.self))
                }
                
                it("Delete Avatar With Error") {
                    sut.avatarUrls = ["A"]
                    sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: indexPath)
                }
            }
        }
    }
}
