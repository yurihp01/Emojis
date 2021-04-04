//
//  ReposViewController.swift
//  emojis
//
//  Created by Yuri Pedroso on 04/04/21.
//

import UIKit

class ReposViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ReposViewModel?
    var repos: [String] = []
    var currentPage = 1
    var refreshControl = UIRefreshControl()
    
    weak var coordinator: ReposCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        getRepos()
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.2407566905, green: 0.3427084684, blue: 0.7042391896, alpha: 1)
    }

    private func getRepos() {
        viewModel?.getRepos(page: currentPage, completion: { [weak self] (repos, error) in
            if let repos = repos {
                self?.repos = repos
                self?.tableView.reloadData()
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        })
    }
}

extension ReposViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.isEmpty ? 0 : 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = repos[indexPath.row]
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            if currentPage >= 2 {
                currentPage -= 1
            }
        } else  {
            currentPage += 1
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            getRepos()
        }
    }
}
