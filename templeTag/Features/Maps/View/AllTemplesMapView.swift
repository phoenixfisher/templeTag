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
    @StateObject private var vm = TempleViewModel()
    @State private var position: MapCameraPosition = .region(
      .init(
        center: .init(latitude: 40.7704, longitude: -111.8919),
        span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
    )
    
    var body: some View {
        ZStack {
            Map(position: $position, selection: $vm.selectedTemple) {
                if locationAuth.canShowUser {
                    UserAnnotation()
                }
                ForEach(vm.temples) { temple in
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
            .onChange(of: vm.selectedTemple) { _, temple in
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
            await vm.load()
        }
    }
}
