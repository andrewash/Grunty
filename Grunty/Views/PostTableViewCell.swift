//
//  PostTableViewCell.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation
import UIKit

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostTableViewCell"
    static let height: CGFloat = 100.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.contentView.backgroundColor = .white
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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

    private func layoutControls() {
        // 1 - Add views
        addSubview(titleLabel)
        addSubview(bodyLabel)

        // 2 - Layout
        let hMargin: CGFloat = 25.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
            contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: hMargin),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
            contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: bodyLabel.trailingAnchor, constant: hMargin),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            bodyLabel.heightAnchor.constraint(equalToConstant: 28.0 * CGFloat(bodyLabel.numberOfLines))
        ])
    }
    
    func updateUI(title: String, body: String) {
        self.titleLabel.text = title
        self.bodyLabel.text = body
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
