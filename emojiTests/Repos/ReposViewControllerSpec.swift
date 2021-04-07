//
//  ReposViewControllerSpec.swift
//  emojiTests
//
//  Created by Yuri Pedroso on 06/04/21.
//

import Quick
import Nimble
@testable import emojis

class MockViewModel: ReposViewModelProtocol {
    func getRepos(page: Int, completion: @escaping ([String]?, Error?) -> Void) {
        switch page {
        case 1:
            completion(["Apple 1", "Apple 2"], nil)
        case 2:
            completion(["Apple 3", "Apple 4"], nil)
        default:
            completion(nil, GithubError.notFound(name: "Repos"))
        }
    }
}

class ReposViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ReposViewController") {
            
            var sut: ReposViewController!
            var cell: UITableViewCell!
            var indexPath: IndexPath!
            
            beforeEach {
                sut = ReposViewController.instantiate(storyboardName: "Repos")
                sut.viewDidLoad()
                sut.viewModel = MockViewModel()
                indexPath = IndexPath(row: 0, section: 0)
            }
            
            afterEach {
                sut = nil
            }
            
            context("Get Repos") {
                it("Get Repos Function") {
                    sut.viewModel?.getRepos(page: 1, completion: { (repos, error) in
                        if let repos = repos {
                            sut.repos = repos
                            sut.tableView.reloadData()
                            cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)

                            expect(sut.repos).to(equal(["Apple 1", "Apple 2"]))
                            expect(error).to(beNil())
                            expect(sut.tableView.dataSource).toNot(beNil())
                            expect(cell).to(beAKindOf(UITableViewCell.self))
                        }
                    })
                }
                
                it("Get Repos Error") {
                    sut.currentPage = 3
                    sut.getRepos()
                }
            }
            
            context("ScrollView") {
                it("Scrolls TableView") {
                    sut.viewModel?.getRepos(page: 1, completion: { (repos, error) in
                        if let repos = repos {
                            sut.repos = repos
                            cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)

                            expect(sut.repos).to(equal(["Apple 1", "Apple 2"]))
                            expect(error).to(beNil())
                            expect(sut.tableView.dataSource).toNot(beNil())
                            
                            // checks if this method will changes the page
                            sut.tableView.delegate?.scrollViewWillBeginDragging?(sut.tableView)
                            expect(sut.currentPage).to(equal(2))
                            
                            // checks if this method will updates the repos values
                            sut.tableView.delegate?.scrollViewDidEndDragging?(sut.tableView, willDecelerate: true)
                            expect(sut.repos).to(equal(["Apple 3", "Apple 4"]))
//                            
//                            var scrollview = UIScrollView()
//                            scrollview.panGestureRecognizer.setTranslation(CGPoint(x: 0, y: 2), in: sut.tableView)
//                            sut.scrollViewWillBeginDragging(scrollview)
//                            print(sut.currentPage)
                        }
                    })
                }
                
                it("Repos Array Is Empty") {
                    let number = sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)
                    expect(sut.repos).to(beEmpty())
                    expect(sut.tableView.dataSource).toNot(beNil())
                    expect(number).to(equal(0))
                }
            }
        }
    }
}
