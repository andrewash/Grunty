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
    var errorTitle: String { NSLocalizedString("Can't Find a Moose", comment: "Can't Find a Moose") }
    var errorMessage: String { NSLocalizedString("Oops, we can't hear all the grunts about this grunt. Please check your Internet connection then tap OK to try again.\n\nError code %@", comment: "Error description") }
    
    let loadingNavTitle = "Loading Comments..."
    
    let post: Post
    var comments: [PostComment] = [] {
        didSet {
            updateUI()
        }
    }
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required designated initializer for storyboards/xibs")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        loadData()
    }

    //==========================================================================
    // MARK: Data-Layer Interactions
    //==========================================================================

    func loadData() {
        self.postCommentsActivityIndicatorView.startAnimating()
        DataStore.shared.retrieveComments(forPostId: post.id) { [weak self] result in
            guard let self = self else { return }
            self.postCommentsActivityIndicatorView.stopAnimating()
            switch result {
            case .success(let comments):
                self.comments = comments
            case .failure(let error):
                self.present(self.makeAlert(error: error, then: { self.loadData() }), animated: true, completion: nil)
            }
        }
    }
    
    func updateUI() {
        self.userLabel.text = post.userName
        self.titleLabel.text = post.title
        self.bodyLabel.text = post.body
        self.postsByAuthor.setTitle("More by \(post.userName)", for: .normal)
        self.postCommentsHeading.text = "\(comments.count) Comments"
        self.postCommentsTableView.reloadData()
    }
    
    
    
    //==========================================================================
    // MARK: View Layout
    //==========================================================================

    private let userAvatar = UIImageView(image: UIImage(named: "AvatarPlaceholder"))
    private let userLabel = UILabel(styledWithFont: .boldSystemFont(ofSize: 20))
    private let titleLabel = UILabel(styledWithFont: .systemFont(ofSize: 20))
    private let bodyLabel = UILabel(styledWithFont: .systemFont(ofSize: 16))
    private let postsByAuthor = UIButton(type: .roundedRect)
    private let postCommentsHeading = UILabel(styledWithFont: .boldSystemFont(ofSize: 20))
    private let postCommentsActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let postCommentsTableView = UITableView()

    func prepareView() {
        self.view.backgroundColor = .white  // for a smooth transition when pushing this VC onto nav stack
        self.postCommentsTableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: PostCommentTableViewCell.identifier)
        self.postCommentsTableView.delegate = self
        self.postCommentsTableView.dataSource = self
        layoutControls()
    }
    
    func layoutControls() {
        let subviews = [userAvatar, userLabel, titleLabel, bodyLabel, postCommentsHeading, postCommentsActivityIndicatorView, postCommentsTableView, postsByAuthor]
        for subview in subviews {
            view.addSubview(subview)
        }
        titleLabel.numberOfLines = 2
        bodyLabel.numberOfLines = 0
        bodyLabel.sizeToFit()
        postCommentsHeading.text = "Comments"
        postCommentsTableView.backgroundColor = .paleCerulean
        postsByAuthor.backgroundColor = UIColor.systemBlue
        postsByAuthor.layer.cornerRadius = 25.0
        postsByAuthor.setTitleColor(.white, for: .normal)
        postsByAuthor.addTarget(self, action: #selector(goPostsByAuthor), for: .touchUpInside)
        
        // Show a user avatar placeholder besides the username so it's clear the name identifies a user
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
            userAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7.0),
            userAvatar.widthAnchor.constraint(equalToConstant: 50.0),
            userAvatar.heightAnchor.constraint(equalTo: userAvatar.widthAnchor)
        ])
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userLabel.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 8.0),
            userLabel.centerYAnchor.constraint(equalTo: userAvatar.centerYAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 25.0),
            userLabel.heightAnchor.constraint(equalToConstant: 30.0)
        ])

        NSLayoutConstraint.activate(Utilities.makeStandardPhoneConstraints(forView: titleLabel,
                                                                           previousView: userLabel,
                                                                           rootView: self.view,
                                                                           topSpacing: 10.0,
                                                                           height: 28.0 * CGFloat(titleLabel.numberOfLines)))
        NSLayoutConstraint.activate(Utilities.makeStandardPhoneConstraints(forView: bodyLabel,
                                                                           previousView: titleLabel,
                                                                           rootView: self.view,
                                                                           topSpacing: 4.0,
                                                                           height: 120.0))

        // Show a comments heading with an activity indicator to the right when comments are loading
        postCommentsHeading.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCommentsHeading.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
            postCommentsHeading.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 32.0),
            postCommentsHeading.widthAnchor.constraint(equalToConstant: 120.0),
            postCommentsHeading.heightAnchor.constraint(equalToConstant: 30.0)
        ])

        postCommentsActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCommentsActivityIndicatorView.leadingAnchor.constraint(equalTo: postCommentsHeading.trailingAnchor, constant: 0.0),
            postCommentsActivityIndicatorView.centerYAnchor.constraint(equalTo: postCommentsHeading.centerYAnchor),
            postCommentsActivityIndicatorView.widthAnchor.constraint(equalToConstant: 36.0),
            postCommentsActivityIndicatorView.heightAnchor.constraint(equalTo: postCommentsActivityIndicatorView.widthAnchor)
        ])

        // Comments appear in a UITableView in the middle, with no fixed height
        postCommentsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCommentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: postCommentsTableView.trailingAnchor, constant: 20),
            postCommentsTableView.topAnchor.constraint(equalTo: postCommentsHeading.bottomAnchor, constant: 4)
        ])

        // Posts By Author appears at bottom of the view
        postsByAuthor.translatesAutoresizingMaskIntoConstraints = false
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

    @objc func goPostsByAuthor() {
        let vc = PostsTableViewController(filterByUserId: self.post.userId)
        navigationController?.pushViewController(vc, animated: true)
    }    
}

extension PostDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    //==========================================================================
    // MARK: UITableViewDataSource
    //==========================================================================

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCommentTableViewCell.identifier) as? PostCommentTableViewCell else {
            return UITableViewCell()
        }
        guard let comment = comment(at: indexPath) else {
            Utilities.debugLog("No data model for UITableViewCell at row \(indexPath.row)")
            return UITableViewCell()
        }
        cell.model = comment
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
    func comment(at indexPath: IndexPath) -> PostComment? {
        if indexPath.row < comments.count { return comments[indexPath.row] }
        return nil
    }
}
