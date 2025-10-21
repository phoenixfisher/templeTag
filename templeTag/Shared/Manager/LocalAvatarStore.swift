//
//  LocalAvatarStore.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/21/25.
//

import UIKit

struct LocalAvatarStore {
    static let shared = LocalAvatarStore()
    private let folder = "Avatars"
    
    func saveAvatarJPEG(data: Data, userId: String) throws {
        let url = try fileURL(userId: userId)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url, options: .atomic)
    }
    
    func loadAvatarJPEG(userId: String) throws -> Data {
        let url = try fileURL(userId: userId)
        return try Data(contentsOf: url)
    }
    
    private func fileURL(userId: String) throws -> URL {
        let dir = try FileManager.default.url(for: .applicationSupportDirectory,
                                              in: .userDomainMask, appropriateFor: nil, create: true)
        return dir.appendingPathComponent(folder).appendingPathComponent("\(userId).jpg")
    }
}
