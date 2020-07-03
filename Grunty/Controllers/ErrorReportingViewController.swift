//
//  ErrorReportingViewController.swift
//  Grunty
//
//  Created by Andrew Ash on 6/30/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//
//  Protocol for a UIViewController that that reports errors using a standard interface,
//   with an UIAlertController containing retry and cancel buttons

import Foundation
import UIKit

protocol ErrorReportingViewController: UIViewController {
    var errorTitle: String { get }
    var errorMessage: String { get }
}

extension ErrorReportingViewController where Self: UIViewController {
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
