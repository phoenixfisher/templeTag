//
//  MapView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationAuth = LocationAuth()
    @State private var position = MapCameraPosition.region(
      .init(center: .init(latitude: 40.7704, longitude: -111.8919),
            span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
    )
    
    var body: some View {
        ZStack {
            Map {
                if locationAuth.canShowUser {
                    UserAnnotation()
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .ignoresSafeArea()
            
            if !locationAuth.canShowUser {
                Button {
                    locationAuth.requestAuthorization()
                } label: {
                    Label("Enable Location", systemImage: "location.circle")
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding()
            }
        }
    }
}
