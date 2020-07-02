//
//  CodableStorage.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

/// CodableStorage allows for saving, loading, and clearing objects which implement the Encodable/Decodable to/from device storage.
struct CodableStorage {
    /// Saves an Encodable array of objects of type T to filename within the caches directory
    /// name is a filename which is computed from type T if not supplied
    static func save<T: Encodable>(_ objects: [T], as name: String? = nil) {
        guard let cacheURL = getCacheDirectory() else {
            Utilities.debugLog("Error: Cache directory not found")
            return
        }
        let filename = name ?? "\(String(describing: T.self))Array.json"
        let destinationURL = cacheURL.appendingPathComponent(filename)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(objects)
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try data.write(to: destinationURL)
        } catch {
            Utilities.debugLog("Error: Cannot save objects of type \(String(describing: T.self)) to disk \(error)")
        }
    }

    /// Loads a Decodable array of objects of type T, sorted, from filename within the caches directory
    /// filename is computed from type T if not supplied
    static func load<T: Decodable & Comparable>(filename name: String? = nil) -> [T]? {
        guard let cacheURL = getCacheDirectory() else {
            Utilities.debugLog("Error: Cache directory not found")
            return nil
        }
        let filename = name ?? "\(String(describing: T.self))Array.json"
        let originURL = cacheURL.appendingPathComponent(filename)
        let decoder = JSONDecoder()
        guard FileManager.default.fileExists(atPath: originURL.path) else {
            return nil
        }
        do {
            guard let data = FileManager.default.contents(atPath: originURL.path) else {
                Utilities.debugLog("Error: Could not read contents of file \(filename) in caches directory")
                return nil
            }
            let objects = try decoder.decode([T].self, from: data)
            return objects.sorted()
        } catch {
            Utilities.debugLog("Error: Could not decode objects of type \(String(describing: T.self)) from filename \(filename) with error \(error)")
            return nil
        }
    }

    /// Removes all documents from the cache directory
    static func clear() {
        guard let cacheURL = getCacheDirectory() else {
            Utilities.debugLog("Error: Cache directory not found")
            return
        }
        guard let enumerator = FileManager.default.enumerator(at: cacheURL, includingPropertiesForKeys: nil) else {
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
            Utilities.debugLog("Error: Could not remove contents of caches directory with error \(error)")
        }
    }

    // MARK: Helpers
    static private func getCacheDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths.first
    }
}
