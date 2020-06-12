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

    
    
    // MARK: Controls
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(bodyLabel)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func layoutControls() {
        
    }

    
    
    // MARK: Helpers
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        bodyLabel.text = nil
    }
    
}
