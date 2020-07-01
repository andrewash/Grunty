//
//  PostsTableViewController.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation
import UIKit

class PostsTableViewController: UITableViewController, ErrorReportingViewController {
    var errorTitle: String { NSLocalizedString("Can't Find a Moose", comment: "Can't Find a Moose") }
    var errorMessage: String { NSLocalizedString("Oops, we can't hear any grunts. Please check your Internet connection then tap OK to try again.\n\nError code %@", comment: "Error description") }
    
    let loadingNavTitle = "Loading Grunts..."
    var activityIndicatorView: UIActivityIndicatorView?     // keeps reference to this view so we can stop it's animation
    let filterByUserId: Int?    /// which user are we filtering for (if nil, no filter is applied)
    var posts: [Post] = []      /// posts to show in this view

    // A beautiful logo at the bottom of the list for some colour
    let tableFooterView: UIView = {
        let view = UIView() // because using constraints anyway
        let logo = UIImageView(image: UIImage(named: "Logo"))
        logo.alpha = 0.7
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalToConstant: 100.0),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()

    init(filterByUserId userId: Int? = nil) {
        self.filterByUserId = userId
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("required designated initializer for storyboards/xibs")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        startActivityIndicator()
        prepareView()
    }

    func prepareView() {
        self.view.backgroundColor = .white
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.tableFooterView = tableFooterView
        navigationItem.title = loadingNavTitle
    }

    //==========================================================================
    // MARK: UITableViewDataSource and UITableViewDelegate
    //==========================================================================
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostTableViewCell.height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else {
            return UITableViewCell()
        }
        guard let post = post(at: indexPath) else {
            Utilities.debugLog("No data model for UITableViewCell at row \(indexPath.row)")
            return UITableViewCell()
        }
        cell.model = post
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = post(at: indexPath) else {
            Utilities.debugLog("No data model for UITableViewCell at row \(indexPath.row)")
            return
        }
        navigationController?.pushViewController(PostDetailsViewController(post: post), animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150.0
    }

    //==========================================================================
    // MARK: Data-Layer Interactions
    //==========================================================================
    func loadData() {
        DataStore.shared.retrievePosts(filterByUserId: filterByUserId) { [weak self] result in
            guard let self = self else { return }
            self.stopActivityIndicator()
            switch result {
            case .success(let posts):
                // 1 - Determine the navigation title
                if let filteringForUserId = self.filterByUserId {
                    self.navigationItem.title = "Moose #\(filteringForUserId)'s Grunts"
                } else {
                    self.navigationItem.title = "Recent \(posts.count) Grunts"
                }
                self.posts = posts
                self.tableView.reloadData()
            case .failure(let error):
                self.present(self.makeAlert(error: error, then: { self.loadData() }), animated: true, completion: nil)
            }
        }
    }

    // Reset database and refresh data
    @objc func reset() {
        self.posts = []
        self.tableView.reloadData()
        self.startActivityIndicator()
        DataStore.shared.reset { [weak self] in
            self?.loadData()
            self?.tableView.reloadData()

        }
    }

    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    func post(at indexPath: IndexPath) -> Post? {
        if indexPath.row < posts.count { return posts[indexPath.row] }
        return nil
    }

    func startActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .white
        navigationItem.title = loadingNavTitle
        navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicatorView), animated: true)
        activityIndicatorView.startAnimating()
        self.activityIndicatorView = activityIndicatorView
    }

    func stopActivityIndicator() {
        self.activityIndicatorView?.stopAnimating()
        showRefreshButtonForAllPosts()
        self.activityIndicatorView = nil
    }
    
    func showRefreshButtonForAllPosts() {
        if filterByUserId == nil {
            let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reset))
            refreshButton.tintColor = .black
            navigationItem.setRightBarButton(refreshButton, animated: true)
        }
    }

}
