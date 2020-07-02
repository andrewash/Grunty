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
    private let spacer: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
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
                
        // 2 - Two horizontal stack views
        let hMargin: CGFloat = 25.0
        // Layout a user avatar placeholder besides the username so it's clear the name identifies a user
        let userStackView = UIStackView(arrangedSubviews: [userAvatar, userLabel])
        userStackView.axis = .horizontal
        userStackView.distribution = .fill
        userStackView.spacing = 8.0
        userStackView.alignment = .center
        userStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let postCommentsHeadingStackView = UIStackView(arrangedSubviews: [postCommentsHeading, postCommentsActivityIndicatorView, spacer])
        postCommentsHeadingStackView.axis = .horizontal
        postCommentsHeadingStackView.distribution = .fill
        postCommentsHeadingStackView.spacing = 0.0
        postCommentsHeadingStackView.alignment = .center
        postCommentsHeadingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 3 - One vertical stack view to bring it all together
        let stackView = UIStackView(arrangedSubviews: [userStackView, titleLabel, bodyLabel, postCommentsHeadingStackView, postCommentsTableView, postsByAuthor])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4.0
        stackView.setCustomSpacing(10.0, after: userStackView)
        stackView.setCustomSpacing(15.0, after: postCommentsTableView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // 4 - stackView takes up most of the screen, with nice margins
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7.0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20.0),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: hMargin),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: hMargin),
        ])
        
        // 5 - Fixed dimensions for some subviews
        NSLayoutConstraint.activate([
            userAvatar.widthAnchor.constraint(equalToConstant: 50.0),
            postCommentsActivityIndicatorView.widthAnchor.constraint(equalToConstant: 36.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 28.0 * CGFloat(titleLabel.numberOfLines)),
            bodyLabel.heightAnchor.constraint(equalToConstant: 150.0),
            postsByAuthor.heightAnchor.constraint(equalToConstant: 48)
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
