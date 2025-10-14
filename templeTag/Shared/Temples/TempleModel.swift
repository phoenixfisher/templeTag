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
    let country: String
    let status: Status
    let state: String?
    let city: String?
    let address: String?
    let website: URL?
    let appointments: URL?
    let photo: URL?
    let photoThumb: URL?
    let photoCredit: String?
    let photoCaption: String?
    let description: String?
    let latitude: Double
    let longitude: Double
    let lastUpdated: Date

    var coordinate: CLLocationCoordinate2D { .init(latitude: latitude, longitude: longitude) }
    
    enum Status: String, Codable {
        case dedicated = "dedicated"
        case under_construction = "under_construction"
        case announced = "announced"
        case renovation = "renovation"
        case unknown = "unknown"
    }
}
