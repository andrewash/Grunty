//
//  Utilities.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation
import UIKit

class Utilities {    
    // Gate all print statements behind a debug check so we don't log insecure data in production
    static func debugLog(_ message: String) {
        #if DEBUG
            print(message)
        #endif
    }
    
    /// Creates a set of common iPhone auto-layout constraints for currentView,
    ///  where currentView is centered in the screen with equal horizontal margins, topSpacing below the previousView, and a fixed height
    /// - currentView is the view we're laying out
    /// - previousView is the view above
    /// - if previousView is nil, then we anchor currentView to rootView, the top of the view hierarchy
    static func makeStandardPhoneConstraints(forView currentView: UIView, previousView: UIView?, rootView: UIView, topSpacing: CGFloat, height: CGFloat, hMargin: CGFloat = CGFloat(25)) -> [NSLayoutConstraint] {
        let topAnchorPoint = previousView?.bottomAnchor ?? rootView.safeAreaLayoutGuide.topAnchor
        return [
            currentView.leadingAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.leadingAnchor, constant: hMargin),
            rootView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: currentView.trailingAnchor, constant: hMargin),
            currentView.topAnchor.constraint(equalTo: topAnchorPoint, constant: topSpacing),
            currentView.heightAnchor.constraint(equalToConstant: height)
        ]
    }
}
