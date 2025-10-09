//
//  TempleModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import Foundation

struct Temple: Identifiable, Codable {
    enum Status: String, Codable { case operating, renovation, construction, announced }
    let id, name, country: String
    let status: Status
    let lat, lng: Double
    let lastUpdated: Date
}
