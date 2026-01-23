//
//  TempleModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import Foundation
import CoreLocation

struct Temple: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let status: Status
    let country: String?
    let state: String?
    let city: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let website: URL?
    let appointments: URL?
    let photo: URL?
    let photoThumb: URL?
    let photoCredit: String?
    let photoCaption: String?
    let description: String?
    let lastUpdated: Date

    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return .init(latitude: lat, longitude: lon)
    }
    
    enum Status: String, Codable {
        case dedicated = "dedicated"
        case under_construction = "under_construction"
        case announced = "announced"
        case renovation = "renovation"
        case unknown = "unknown"
    }
}
