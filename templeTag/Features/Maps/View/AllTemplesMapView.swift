//
//  AllTemplesMapView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI
import MapKit

struct AllTemplesMapView: View {
    @StateObject private var locationAuth = LocationAuth()
    @StateObject private var templeVM = TempleViewModel()
    @State private var position: MapCameraPosition = .region(
      .init(
        center: .init(latitude: 40.7704, longitude: -111.8919),
        span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
    )
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position, selection: $templeVM.selectedTemple) {
                if locationAuth.canShowUser {
                    UserAnnotation()
                }
                ForEach(templeVM.temples) { temple in
                    Marker(temple.name, systemImage: "building.columns.fill", coordinate: temple.coordinate)
                        .tag(temple)
                }
            }
            .mapControls {
                if locationAuth.canShowUser {
                    MapUserLocationButton()
                }
                MapCompass()
            }
            .onChange(of: templeVM.selectedTemple) { _, temple in
                guard let coords = temple?.coordinate else { return }
                withAnimation(.easeInOut) {
                    position = .region(
                        MKCoordinateRegion(center: coords, latitudinalMeters: 500, longitudinalMeters: 500)
                    )
                }
            }
            
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
        .task {
            await templeVM.load()
            
            if locationAuth.canShowUser, let userCoord = locationAuth.location {
                // Center the map on user’s location
                withAnimation(.easeInOut) {
                    position = .region(
                        MKCoordinateRegion(
                            center: userCoord,
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        )
                    )
                }
            } else {
                // Ask for authorization if not yet granted
                locationAuth.requestAuthorization()
            }
        }
    }
}

#Preview {
    AllTemplesMapView()
}
