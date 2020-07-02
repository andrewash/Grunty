//
//  ErrorReportingViewController.swift
//  Grunty
//
//  Created by Andrew Ash on 6/30/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorReportingViewController {
    var errorTitle: String { get }
    var errorMessage: String { get }
}

extension ErrorReportingViewController {
    func makeAlert(errorDetails: String, retryHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: errorTitle,
                                      message: String(format: errorMessage, errorDetails),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: .default,
                                      handler: { (_) -> Void in retryHandler() }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { (_) -> Void in cancelHandler() }))
        return alert
    }
}
