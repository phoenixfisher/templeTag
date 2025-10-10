//
//  TempleClient.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import Foundation

final class TempleClient {
    private let base = URL(string: "https://templetag.temple-api.workers.dev/v1")!
    private let session = URLSession.shared
    private let etagKey = "temples-etag"

    func fetchTemples() async throws -> [Temple] {
      var req = URLRequest(url: base.appendingPathComponent("temples"))
      if let etag = UserDefaults.standard.string(forKey: etagKey) {
        req.addValue(etag, forHTTPHeaderField: "If-None-Match")
      }
      let (data, resp) = try await session.data(for: req)
      guard let http = resp as? HTTPURLResponse else { throw URLError(.badServerResponse) }

      if http.statusCode == 304 { return try loadFromDisk() }
      if let newETag = http.value(forHTTPHeaderField: "ETag") {
        UserDefaults.standard.setValue(newETag, forKey: etagKey)
      }
      let dec = JSONDecoder(); dec.dateDecodingStrategy = .iso8601
      let items = try dec.decode([Temple].self, from: data)
      try saveToDisk(items)
      return items
    }

    private func cacheURL() -> URL {
      FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("temples.json")
    }
    private func saveToDisk(_ items: [Temple]) throws {
      let enc = JSONEncoder(); enc.dateEncodingStrategy = .iso8601
      let data = try enc.encode(items)
      try data.write(to: cacheURL(), options: .atomic)
    }
    private func loadFromDisk() throws -> [Temple] {
      let data = try Data(contentsOf: cacheURL())
      let dec = JSONDecoder(); dec.dateDecodingStrategy = .iso8601
      return try dec.decode([Temple].self, from: data)
    }
}
