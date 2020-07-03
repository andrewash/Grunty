//
//  UILabel.swift
//  Grunty
//
//  Created by Andrew Ash on 7/1/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//
//  Generate labels with consistent styling

import Foundation
import UIKit

extension UILabel {
    convenience init(styledWithFont font: UIFont, textAlignment: NSTextAlignment = .natural) {
        self.init()
        self.textColor = .black
        self.font = font
        self.textAlignment = textAlignment
        self.lineBreakMode = .byTruncatingTail
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
