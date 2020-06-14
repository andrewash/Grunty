//
//  PostCommentTableViewCell.swift
//  Grunty
//
//  Created by Andrew Ash on 6/13/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation
import UIKit

class PostCommentTableViewCell: UITableViewCell {
    let cellIdentifier = "PostCommentCell"
    static let standardCellHeight: CGFloat = 66.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .paleCerulean
        addSubviews()
        layoutControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: PostComment! {
        didSet {
            self.titleLabel.text = model.title
            self.emailLabel.text = "by \(model.postedByEmail.lowercased())"
            self.bodyLabel.text = model.body
        }
    }

    //==========================================================================
    // MARK: Controls
    //==========================================================================
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(emailLabel)
        addSubview(bodyLabel)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func layoutControls() {
        NSLayoutConstraint.activate(Utilities.makeStandardPhoneConstraints(forView: titleLabel,
                                                                           previousView: nil,
                                                                           rootView: self.contentView,
                                                                           topSpacing: 5.0,
                                                                           height: 20.0))
        NSLayoutConstraint.activate(Utilities.makeStandardPhoneConstraints(forView: emailLabel,
                                                                           previousView: titleLabel,
                                                                           rootView: self.contentView,
                                                                           topSpacing: 5.0,
                                                                           height: 20.0))
        NSLayoutConstraint.activate(Utilities.makeStandardPhoneConstraints(forView: bodyLabel,
                                                                           previousView: emailLabel,
                                                                           rootView: self.contentView,
                                                                           topSpacing: 5.0,
                                                                           height: 20.0 * CGFloat(bodyLabel.numberOfLines)))
    }
    
    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        bodyLabel.text = nil
    }
    
}

