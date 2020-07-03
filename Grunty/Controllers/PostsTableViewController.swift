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
    private let viewModel: PostsViewModel

    // Keeps a reference to this view so we can stop it's animation
    var activityIndicatorView: UIActivityIndicatorView?
    var errorTitle: String { "Can't Find a Moose" }
    var errorMessage: String { "Oops, we can't hear any grunts. Please check your Internet connection then tap Retry to try again.\n\nError: %@" }

    init(viewModel: PostsViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        self.viewModel.updateHandler = updateUI
        self.viewModel.errorHandler = errorHandler
    }

    required init?(coder: NSCoder) {
        fatalError("required designated initializer for storyboards/xibs")
    }

    //==========================================================================
    // MARK: View Layout
    //==========================================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    func prepareView() {
        view.backgroundColor = .white
        navigationItem.title = viewModel.titleForScreen
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.tableFooterView = tableFooterView
        updateUI()
    }

    // A beautiful logo at the bottom of the list for some colour
    private let tableFooterView: UIView = {
        let footerLength: CGFloat = 100.0
        let view = UIView(frame: CGRect(x: 0, y: 0, width: footerLength, height: footerLength))
        let logo = UIImageView(image: UIImage(named: "Logo"))
        logo.alpha = 0.7
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalToConstant: footerLength),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()

    
    //==========================================================================
    // MARK: Actions
    //==========================================================================

    /// Update the UI based on the current state of the viewModel
    func updateUI() {
        navigationItem.title = viewModel.titleForScreen
        // Show an activity indicator when view model is loading
        if viewModel.isLoading {
            startActivityIndicator()
        } else {
            stopActivityIndicator()
        }
        tableView.reloadData()
    }

    // Ask view model to clear caches and reload data
    @objc func reset() {
        viewModel.reset()
    }
    

    //==========================================================================
    // MARK: UITableViewDataSource and UITableViewDelegate
    //==========================================================================
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostTableViewCell.height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else {
            return UITableViewCell()
        }
        guard let post = viewModel.post(at: indexPath.row) else {
            Utilities.debugLog("No data model for UITableViewCell at row \(indexPath.row)")
            return UITableViewCell()
        }
        cell.updateUI(title: post.title, body: post.body)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let relatedViewModel = viewModel.makePostDetailsViewModel(at: indexPath.row) else {
            Utilities.debugLog("No view model available at row \(indexPath.row) to instantiate PostDetailsViewController")
            return
        }
        navigationController?.pushViewController(PostDetailsViewController(viewModel: relatedViewModel), animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150.0
    }
    

    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    func startActivityIndicator() {
        if self.activityIndicatorView?.isAnimating == true { return }
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .black
        navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicatorView), animated: true)
        activityIndicatorView.startAnimating()
        self.activityIndicatorView = activityIndicatorView
    }

    func stopActivityIndicator() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView = nil
        if viewModel.isRefreshButtonAvailable {
            showRefreshButton()
        }
    }

    func showRefreshButton() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reset))
        refreshButton.tintColor = .black
        navigationItem.setRightBarButton(refreshButton, animated: true)
    }

    func errorHandler(errorDetails: String) {
        present(
            makeAlert(errorDetails: errorDetails,
                           retryHandler: { [weak self] in
                            self?.viewModel.reset() },
                           cancelHandler: { [weak self] in
                            self?.updateUI()
            }),
            animated: true,
            completion: nil
        )
    }
}
