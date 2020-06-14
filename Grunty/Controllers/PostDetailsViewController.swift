//
//  PostDetailsViewController.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation
import UIKit

class PostDetailsViewController: UIViewController {
    let loadingNavTitle = "Loading Comments..."
    let cellIdentifier = "PostCommentCell"
    
    var post: Post! {       // which album was selected in PostsTableViewController
        didSet {
            self.userLabel.text = "Moose #\(post.userId)"
            self.titleLabel.text = post.title
            self.bodyLabel.text = post.body
            self.postsByAuthor.setTitle("More by \(userLabel.text ?? "this author")", for: .normal)
        }
    }
    var comments: [PostComment] = [] {
        didSet {
            self.postCommentsHeading.text = "\(comments.count) Comments"
            self.postCommentsTableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            self.postCommentsTableView.delegate = self
            self.postCommentsTableView.dataSource = self
            self.postCommentsTableView.reloadData()
        }
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
            self?.postCommentsActivityIndicatorView.stopAnimating()
            switch result {
            case .success(let comments):
                self?.comments = comments
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
        let alert = UIAlertController(title: "Can't Find Moose", message: "Oops, we can't hear all the grunts about this grunt. Please check your Internet connection then tap OK to try again.\n\nError code \(errorCode)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> () in
            retryHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //==========================================================================
    // MARK: View Layout
    //==========================================================================
    
    // TODO: Include a profile photo placeholder
    private let userLabel: UILabel = makeStyledLabel(font: .boldSystemFont(ofSize: 18), textAlignment: .natural)
    private let titleLabel: UILabel = makeStyledLabel(font: .systemFont(ofSize: 18), textAlignment: .natural)
    private let bodyLabel: UILabel = makeStyledLabel(font: .systemFont(ofSize: 16), textAlignment: .natural)
    private let postsByAuthor: UIButton = UIButton(type: .roundedRect)
    private let postCommentsHeading: UILabel = makeStyledLabel(font: .boldSystemFont(ofSize: 18), textAlignment: .natural)
    private let postCommentsActivityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let postCommentsTableView = UITableView()
    
    func prepareView() {
        self.view.backgroundColor = .white  // for a smooth transition when pushing this VC onto nav stack
        addSubviews()
        layoutControls()
    }
    
    func addSubviews() {
        let subviews = [userLabel, titleLabel, bodyLabel, postCommentsHeading, postCommentsActivityIndicatorView, postCommentsTableView, postsByAuthor]
        for subview in subviews {
            view.addSubview(subview)
        }
        bodyLabel.numberOfLines = 0
        bodyLabel.sizeToFit()
        postCommentsHeading.text = "Comments"
        postCommentsTableView.backgroundColor = .paleCerulean
        postsByAuthor.backgroundColor = UIColor.systemBlue
        postsByAuthor.setTitleColor(.white, for: .normal)
        postsByAuthor.addTarget(self, action: #selector(goPostsByAuthor), for: .touchUpInside)
    }
            
    func layoutControls() {
        NSLayoutConstraint.activate(Utilities.makeStandardPhoneConstraints(forView: userLabel,
                                                                           previousView: nil,
                                                                           rootView: self.view,
                                                                           topSpacing: 7.0,
                                                                           height: 30.0))
        NSLayoutConstraint.activate(Utilities.makeStandardPhoneConstraints(forView: titleLabel,
                                                                           previousView: userLabel,
                                                                           rootView: self.view,
                                                                           topSpacing: 0.0,
                                                                           height: 28.0))
        NSLayoutConstraint.activate(Utilities.makeStandardPhoneConstraints(forView: bodyLabel,
                                                                           previousView: titleLabel,
                                                                           rootView: self.view,
                                                                           topSpacing: 4.0,
                                                                           height: 120.0))
        
        // Show a comments heading with an activity indicator to the right when comments are loading
        postCommentsHeading.translatesAutoresizingMaskIntoConstraints = false
        let postCommentsHeadingConstraints = [
            postCommentsHeading.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
            postCommentsHeading.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8.0),
            postCommentsHeading.widthAnchor.constraint(equalToConstant: 110.0),
            postCommentsHeading.heightAnchor.constraint(equalToConstant: 30.0)
        ]
        NSLayoutConstraint.activate(postCommentsHeadingConstraints)
        
        postCommentsActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        let postCommentsActivityIndicatorViewConstraints = [
            postCommentsActivityIndicatorView.leadingAnchor.constraint(equalTo: postCommentsHeading.trailingAnchor, constant: 0.0),
            postCommentsActivityIndicatorView.centerYAnchor.constraint(equalTo: postCommentsHeading.centerYAnchor),
            postCommentsActivityIndicatorView.widthAnchor.constraint(equalToConstant: 36.0),
            postCommentsActivityIndicatorView.heightAnchor.constraint(equalTo: postCommentsActivityIndicatorView.widthAnchor)
        ]
        NSLayoutConstraint.activate(postCommentsActivityIndicatorViewConstraints)
        
        // Comments appear in a UITableView in the middle, with no fixed height
        postCommentsTableView.translatesAutoresizingMaskIntoConstraints = false
        let postCommentsConstraints = [
            postCommentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: postCommentsTableView.trailingAnchor, constant: 20),
            postCommentsTableView.topAnchor.constraint(equalTo: postCommentsHeading.bottomAnchor, constant: 4)
        ]
        NSLayoutConstraint.activate(postCommentsConstraints)
        
        // Posts By Author appears at bottom of the view
        postsByAuthor.translatesAutoresizingMaskIntoConstraints = false
        let postsByAuthorConstraints = [
            postsByAuthor.topAnchor.constraint(equalTo: postCommentsTableView.bottomAnchor, constant: 15),
            postsByAuthor.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: postsByAuthor.trailingAnchor, constant: 20),
            postsByAuthor.heightAnchor.constraint(equalToConstant: 48),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: postsByAuthor.bottomAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(postsByAuthorConstraints)
    }
    
    
    //==========================================================================
    // MARK: Actions
    //==========================================================================
    
    @objc func goPostsByAuthor() {
        let vc = PostsTableViewController(filterByUserId: self.post.userId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    
    /// Generate labels with consistent styling
    static func makeStyledLabel(font: UIFont, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = font
        label.textAlignment = textAlignment
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PostCommentTableViewCell else {
            return UITableViewCell()
        }
        guard isDataAvailable(rowIndex: indexPath.row) else {
            Utilities.debugLog("No data model for UITableViewCell at row \(indexPath.row)")
            return UITableViewCell()
        }
        cell.model = comments[indexPath.row]
        return cell
    }
    
    
    //==========================================================================
    // MARK: UITableViewDelegate
    //==========================================================================
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0    // TODO: Fix
    }
    
    
    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    /// Is there data available for a given row index?
    func isDataAvailable(rowIndex: Int) -> Bool {
        return rowIndex >= 0 && rowIndex < comments.count
    }
}
