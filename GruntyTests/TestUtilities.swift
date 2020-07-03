//
//  TestUtilities.swift
//  GruntyTests
//
//  Created by Andrew Ash on 7/3/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

class TestUtilities {
    static func loadObjectFromJSON<T: Decodable>(filename: String) -> T? {
        let bundle = Bundle(for: TestUtilities.self)
        guard
            let path = bundle.path(forResource: filename, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            FileManager.default.fileExists(atPath: path) else
        {
            print("Error: Cannot locate or load json")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error: Could not decode test object with error \(error)")
            return nil
        }
    }
}
