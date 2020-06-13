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
    
    var post: Post! {       // which album was selected in PostsTableViewController
        didSet {
            self.userLabel.text = "Moose #\(post.userId)"
            self.titleLabel.text = post.title
            self.bodyLabel.text = post.body
            self.postsByAuthor.setTitle("More by \(userLabel.text ?? "this author")", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        loadData()
    }

    
    //==========================================================================
    // MARK: Data-Layer Interactions
    //==========================================================================
    
    func loadData() {
        // TODO: Load Comments
//        DataStore.shared.retrievePosts { [weak self] result in
//            self?.stopActivityIndicator()
//            switch result {
//            case .success(let posts):
//                self?.navigationItem.title = "All Grunts"
//                self?.posts = posts
//                self?.tableView.reloadData()
//            case .failure(let error):
//                switch error {
//                case .noDataReturned:
//                    self?.alert(errorCode: "noDataReturned") { self?.loadData() }
//                case .decodeFailed:
//                    self?.alert(errorCode: "decodeFailed") { self?.loadData() }
//                case .dataTaskFailed:
//                    self?.alert(errorCode: "dataTaskFailed") { self?.loadData() }
//                }
//            }
//        }
    }
    
    func alert(errorCode: String, then retryHandler: @escaping () -> ()) {
        let alert = UIAlertController(title: "Can't Find a Moose", message: "Oops, we can't hear any grunts. Please check your Internet connection then tap OK to try again.\n\nError code \(errorCode)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> () in
            retryHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //==========================================================================
    // MARK: View Layout
    //==========================================================================
    
    // TODO: Include a profile photo placeholder
    private var activityIndicatorView: UIActivityIndicatorView?     // keeps reference to this view so we can stop it's animation
    private let userLabel: UILabel = makeStyledLabel(font: .boldSystemFont(ofSize: 18), textAlignment: .natural)
    private let titleLabel: UILabel = makeStyledLabel(font: .systemFont(ofSize: 18), textAlignment: .natural)
    private let bodyLabel: UILabel = makeStyledLabel(font: .systemFont(ofSize: 16), textAlignment: .natural)
    private let postsByAuthor: UIButton = UIButton(type: .roundedRect)
    
    func styleView() {
        self.view.backgroundColor = .white  // for a smooth transition when pushing this VC onto nav stack
        addSubviews()
        layoutControls()
    }
    
    func addSubviews() {
        let subviews = [userLabel, titleLabel, bodyLabel, postsByAuthor]
        for subview in subviews {
            view.addSubview(subview)
        }
        bodyLabel.numberOfLines = 0
        bodyLabel.sizeToFit()
        postsByAuthor.backgroundColor = UIColor.systemBlue
        postsByAuthor.setTitleColor(.white, for: .normal)
        postsByAuthor.addTarget(self, action: #selector(goPostsByAuthor), for: .touchUpInside)
    }
            
    func layoutControls() {
        NSLayoutConstraint.activate(makeConstraints(forView: userLabel, previousView: nil, topSpacing: CGFloat(7), height: CGFloat(30)))
        NSLayoutConstraint.activate(makeConstraints(forView: titleLabel, previousView: userLabel, topSpacing: CGFloat(0), height: CGFloat(28)))
        NSLayoutConstraint.activate(makeConstraints(forView: bodyLabel, previousView: titleLabel, topSpacing: CGFloat(4), height: CGFloat(120)))
        
        postsByAuthor.translatesAutoresizingMaskIntoConstraints = false
        let postsByAuthorConstraints = [
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
        print("goPostsByAuthor tapped")
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
    
    /// Creates a set of auto-layout constraints for a given label
    /// - currentView is the view we're creating constraints for
    /// - previousView is the view above and to the left of the current view
    /// - if previousView is nil, then anchor currentView to the top of the screen
    /// - we layout constraints from top-left)
    func makeConstraints(forView currentView: UIView, previousView: UIView?, topSpacing: CGFloat = CGFloat(4), height: CGFloat = CGFloat(28)) -> [NSLayoutConstraint] {
        let topAnchorPoint = previousView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor
        return [
            currentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: currentView.trailingAnchor, constant: 25),
            currentView.topAnchor.constraint(equalTo: topAnchorPoint, constant: topSpacing),
            currentView.heightAnchor.constraint(equalToConstant: height)
        ]
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
        self.activityIndicatorView = nil
    }
}
