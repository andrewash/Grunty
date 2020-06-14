//
//  CodableStorage.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

/// CodableStorage allows for saving, loading, and clearing objects which implement the Encodable/Decodable to/from device storage.
class CodableStorage {
    /// Saves an Encodable object of type T to fileName within the caches directory
    static func save<T: Encodable>(_ object: T, as filename: String ) {
        let destinationURL = getCacheDirectory().appendingPathComponent(filename)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            FileManager.default.createFile(atPath: destinationURL.path, contents: data, attributes: nil)
        } catch {
            Utilities.debugLog("Error: Cannot save object to disk")
        }
    }

    /// Loads a Decodable object of type T from filename within the caches directory
    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        let originURL = getCacheDirectory().appendingPathComponent(filename)
        let decoder = JSONDecoder()
        guard FileManager.default.fileExists(atPath: originURL.path) else {
            return nil
        }
        do {
            guard let data = FileManager.default.contents(atPath: originURL.path) else {
                Utilities.debugLog("Error: Could not read contents of file \(filename) in caches directory")
                return nil
            }
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            Utilities.debugLog("Error: Could not decode object of type \(type) from filename \(filename)")
            return nil
        }
    }

    /// Removes all documents from the cache directory
    static func clear() {
        let url = getCacheDirectory()
        guard let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) else {
            Utilities.debugLog("Could not clear cache directory of JSON files")
            return
        }
        do {
            for file in enumerator {
                if let fileUrl = file as? URL,
                fileUrl.pathExtension == "json" {
                    try FileManager.default.removeItem(at: fileUrl)
                }
            }
        } catch {
            Utilities.debugLog("Error: Could not remove contents of caches directory")
        }
    }

    // MARK: Helpers
    static private func getCacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let cachePath = paths.first else {
            fatalError("Error: No path found for default cache directory")
        }
        return cachePath
    }
}
