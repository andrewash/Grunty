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
}
