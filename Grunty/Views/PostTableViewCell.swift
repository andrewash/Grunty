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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        addSubviews()
        layoutControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: Post! {
        didSet {
            self.titleLabel.text = model.title
            self.bodyLabel.text = model.body
        }
    }

    //==========================================================================
    // MARK: Controls
    //==========================================================================
    func addSubviews() {
        addSubview(titleLabel)
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
        let titleLabelHeight: CGFloat = 20.0
        let bodyLabelHeight: CGFloat = titleLabelHeight * CGFloat(bodyLabel.numberOfLines)
        let labelVSpacing: CGFloat = 5.0
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight)
        ]
        let bodyLabelConstraints = [
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: labelVSpacing),
            bodyLabel.heightAnchor.constraint(equalToConstant: bodyLabelHeight)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(bodyLabelConstraints)
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
