//
//  ShowOnMap.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/10/25.
//

import SwiftUI
import MapKit

struct ShowOnMap: View {
    @StateObject private var locationAuth = LocationAuth()
    @State private var position: MapCameraPosition
    
    let coordinate: CLLocationCoordinate2D
    let label: String

    init(coordinate: CLLocationCoordinate2D, label: String = "") {
        self.coordinate = coordinate
        self.label = label
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        _position = State(initialValue: .region(region))
    }

    var body: some View {
        Map(position: $position) {
            if locationAuth.canShowUser {
                UserAnnotation()
            }
            Marker(label, coordinate: coordinate)
        }
        .mapControls {
            if locationAuth.canShowUser {
                MapUserLocationButton()
            }
            MapCompass()
        }
    }
}
