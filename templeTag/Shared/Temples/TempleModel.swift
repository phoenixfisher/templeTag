//
//  TempleModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import Foundation
import CoreLocation

struct Temple: Identifiable, Codable, Equatable, Hashable {
    enum Status: String, Codable { case operating, renovation, construction, announced }
    let id, name, country: String
    let status: Status
    let lat, lng: Double
    let lastUpdated: Date
    
    var coordinate: CLLocationCoordinate2D { .init(latitude: lat, longitude: lng) }
}
