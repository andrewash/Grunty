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
    static let identifier = "PostCommentTableViewCell"
    static let height: CGFloat = 120.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .paleCerulean
        layoutControls()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //==========================================================================
    // MARK: Controls
    //==========================================================================

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .natural
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
        // 1 - Add views
        let stackView = UIStackView(arrangedSubviews: [titleLabel, emailLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        // 2 - Layout
        let hMargin: CGFloat = 25.0
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: hMargin),
            contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: hMargin),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5.0)
        ])
    }
    
    func updateUI(title: String, email: String, body: String) {
        self.titleLabel.text = title
        self.emailLabel.text = email
        self.bodyLabel.text = body
    }
    

    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        emailLabel.text = nil
        bodyLabel.text = nil
    }

}
