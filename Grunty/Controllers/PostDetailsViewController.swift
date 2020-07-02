//
//  PostDetailsViewController.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation
import UIKit

class PostDetailsViewController: UIViewController, ErrorReportingViewController {
    private let viewModel: PostDetailsViewModel
    
    var errorTitle: String { NSLocalizedString("Can't Find a Moose", comment: "Can't Find a Moose") }
    var errorMessage: String { NSLocalizedString("Oops, we can't hear all the grunts about this grunt. Please check your Internet connection then tap Retry to try again.\n\nError: %@", comment: "Error description") }
    
    init(viewModel: PostDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.updateHandler = updateUI
        self.viewModel.errorHandler = errorHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("required designated initializer for storyboards/xibs")
    }
    
    deinit {
        postCommentsTableView.delegate = nil
        postCommentsTableView.dataSource = nil
    }
    
    
    //==========================================================================
    // MARK: View Layout
    //==========================================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white  // for a smooth transition when pushing this VC onto nav stack
        layoutViews()
        updateUI()
    }

    private let userAvatar: UIImageView = {
        let view = UIImageView(image: UIImage(named: "AvatarPlaceholder"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let userLabel: UILabel = {
        let label = UILabel(styledWithFont: .boldSystemFont(ofSize: 20))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(styledWithFont: .systemFont(ofSize: 20))
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let bodyLabel: UILabel = {
        let label = UILabel(styledWithFont: .systemFont(ofSize: 16))
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let postCommentsHeading: UILabel = {
        let label = UILabel(styledWithFont: .boldSystemFont(ofSize: 20))
        label.text = "Comments"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let postCommentsActivityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let postCommentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .paleCerulean
        tableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: PostCommentTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let postsByAuthor: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25.0
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goPostsByAuthor), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func layoutViews() {
        // 1 - Configure UITableView
        postCommentsTableView.delegate = self
        postCommentsTableView.dataSource = self
        
        // 2 - Add views
        let subviews = [userAvatar, userLabel, titleLabel, bodyLabel, postCommentsHeading, postCommentsActivityIndicatorView, postCommentsTableView, postsByAuthor]
        for subview in subviews {
            view.addSubview(subview)
        }
        
        // 3 - Layout
        let hMargin: CGFloat = 25.0
        // Layout a user avatar placeholder besides the username so it's clear the name identifies a user
        NSLayoutConstraint.activate([
            userAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: hMargin),
            userAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7.0),
            userAvatar.widthAnchor.constraint(equalToConstant: 50.0),
            userAvatar.heightAnchor.constraint(equalTo: userAvatar.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            userLabel.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 8.0),
            userLabel.centerYAnchor.constraint(equalTo: userAvatar.centerYAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: hMargin),
            userLabel.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        // Layout title and body with custom vertical spacing
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: hMargin),
            titleLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 28.0 * CGFloat(titleLabel.numberOfLines))
        ])
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: hMargin),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: bodyLabel.trailingAnchor, constant: hMargin),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            bodyLabel.heightAnchor.constraint(equalToConstant: 120.0)
        ])
        
        // Layout a comments heading with an activity indicator to the right when comments are loading
        NSLayoutConstraint.activate([
            postCommentsHeading.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
            postCommentsHeading.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 32.0),
            postCommentsHeading.widthAnchor.constraint(equalToConstant: 120.0),
            postCommentsHeading.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        NSLayoutConstraint.activate([
            postCommentsActivityIndicatorView.leadingAnchor.constraint(equalTo: postCommentsHeading.trailingAnchor, constant: 0.0),
            postCommentsActivityIndicatorView.centerYAnchor.constraint(equalTo: postCommentsHeading.centerYAnchor),
            postCommentsActivityIndicatorView.widthAnchor.constraint(equalToConstant: 36.0),
            postCommentsActivityIndicatorView.heightAnchor.constraint(equalTo: postCommentsActivityIndicatorView.widthAnchor)
        ])

        // Comments are laid out in a UITableView in the middle, with no fixed height
        NSLayoutConstraint.activate([
            postCommentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: postCommentsTableView.trailingAnchor, constant: 20),
            postCommentsTableView.topAnchor.constraint(equalTo: postCommentsHeading.bottomAnchor, constant: 4)
        ])

        // Layout Posts By Author at bottom of the view
        NSLayoutConstraint.activate([
            postsByAuthor.topAnchor.constraint(equalTo: postCommentsTableView.bottomAnchor, constant: 15),
            postsByAuthor.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: postsByAuthor.trailingAnchor, constant: 20),
            postsByAuthor.heightAnchor.constraint(equalToConstant: 48),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: postsByAuthor.bottomAnchor, constant: 20)
        ])
    }
    
    
    //==========================================================================
    // MARK: Actions
    //==========================================================================
    
    func updateUI() {        
        userLabel.text = viewModel.postAuthor
        titleLabel.text = viewModel.postTitle
        bodyLabel.text = viewModel.postBody
        postsByAuthor.setTitle(viewModel.postsByAuthorButtonTitle, for: .normal)
        postCommentsHeading.text = viewModel.commentsHeading
        // Show an activity indicator when view model is loading
        if viewModel.isLoading {
            postCommentsActivityIndicatorView.startAnimating()
        } else {
            postCommentsActivityIndicatorView.stopAnimating()
        }
        postCommentsTableView.reloadData()
    }
    
    @objc func goPostsByAuthor() {
        guard let relatedViewModel = viewModel.makePostsWithSameAuthorViewModel() else {
            Utilities.debugLog("No view model available to instantiate PostsTableViewController")
            return
        }
        navigationController?.pushViewController(PostsTableViewController(viewModel: relatedViewModel), animated: true)
    }
}

extension PostDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    //==========================================================================
    // MARK: UITableViewDataSource
    //==========================================================================

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfComments
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCommentTableViewCell.identifier) as? PostCommentTableViewCell else {
            return UITableViewCell()
        }
        guard let comment = viewModel.comment(at: indexPath.row) else {
            Utilities.debugLog("No data model for UITableViewCell at row \(indexPath.row)")
            return UITableViewCell()
        }
        cell.updateUI(title: comment.title, email: comment.postedByEmail, body: comment.body)
        return cell
    }

    
    //==========================================================================
    // MARK: UITableViewDelegate
    //==========================================================================

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostCommentTableViewCell.height
    }

    
    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    
    func errorHandler(errorDetails: String) {
        self.present(
            self.makeAlert(errorDetails: errorDetails,
                           retryHandler: { [weak self] in
                            self?.viewModel.reloadComments() },
                           cancelHandler: { [weak self] in
                            self?.updateUI()
            } ),
            animated: true,
            completion: nil
        )
    }
}
