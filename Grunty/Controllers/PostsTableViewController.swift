//
//  PostsTableViewController.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation
import UIKit

class PostsTableViewController: UITableViewController {
    let cellIdentifier = "PostCell"
    let loadingNavTitle = "Loading Grunts..."
    var activityIndicatorView: UIActivityIndicatorView?     // keeps reference to this view so we can stop it's animation
    var posts: [Post] = []      /// posts to show in this view
    static let standardCellHeight: CGFloat = 100.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startActivityIndicator()
        prepareView()
        loadData()
    }
    
    func prepareView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.title = loadingNavTitle
    }
    
    
    
    //==========================================================================
    // MARK: UITableViewDataSource and UITableViewDelegate
    //==========================================================================
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostsTableViewController.standardCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PostTableViewCell else {
            return UITableViewCell()
        }
        guard isDataAvailable(rowIndex: indexPath.row) else {
            Utilities.debugLog("No data model for UITableViewCell at row \(indexPath.row)")
            return UITableViewCell()
        }
        cell.model = posts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isDataAvailable(rowIndex: indexPath.row) else {
            Utilities.debugLog("No data model for UITableViewCell at row \(indexPath.row)")
            return
        }
        let vc = PostDetailsTableViewController()
        vc.post = posts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //==========================================================================
    // MARK: Data-Layer Interactions
    //==========================================================================
    func loadData() {
        DataStore.shared.retrievePosts { [weak self] result in
            self?.stopActivityIndicator()
            switch result {
            case .success(let posts):
                self?.navigationItem.title = "All Grunts"
                self?.posts = posts
                self?.tableView.reloadData()
            case .failure(let error):
                switch error {
                case .noDataReturned:
                    self?.alert(errorCode: "noDataReturned") { self?.loadData() }
                case .decodeFailed:
                    self?.alert(errorCode: "decodeFailed") { self?.loadData() }
                case .dataTaskFailed:
                    self?.alert(errorCode: "dataTaskFailed") { self?.loadData() }
                }
            }
        }
    }
    
    func alert(errorCode: String, then retryHandler: @escaping () -> ()) {
        let alert = UIAlertController(title: "Can't Find a Moose", message: "Oops, we can't hear any grunts. Please check your Internet connection then tap OK to try again.\n\nError code \(errorCode)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> () in
            retryHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Reset database and refresh data
    @objc func reset() {
        self.startActivityIndicator()
        DataStore.shared.reset { [weak self] in
            self?.tableView.reloadData()
            self?.loadData()
        }
    }

    
    
    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    /// Is there data available for a given row index?
    func isDataAvailable(rowIndex: Int) -> Bool {
        return rowIndex >= 0 && rowIndex < posts.count
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
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reset))
        refreshButton.tintColor = .white
        navigationItem.setRightBarButton(refreshButton, animated: true)
        self.activityIndicatorView = nil
    }
    
    
}
