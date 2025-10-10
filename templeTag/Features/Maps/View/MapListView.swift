//
//  MapListView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/10/25.
//

import SwiftUI
import Combine

struct MapListView: View {
    @StateObject private var mapsVM = MapsViewModel(templeVM: TempleViewModel())
    @StateObject private var locationAuth = LocationAuth()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Nearest Temple")
                        .font(.title)
                        .bold()
                        .padding()

                    // 1) Check permission, then bind nearestTemple safely
                    if locationAuth.canShowUser, let nearest = mapsVM.nearestTemple {
                        let coordinate = nearest.coordinate
                        NavigationLink(destination: ShowOnMap(coordinate: coordinate, label: nearest.name)) {
                            HStack {
                                ShowOnMap(coordinate: coordinate, label: nearest.name)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 160)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))

                                Text("View Temple Nearest to Me")
                                Image(systemName: "chevron.right")
                            }
                        }

                    // Have permission but no nearest temple yet
                    } else if locationAuth.canShowUser {
                        // show a friendly placeholder while the app calculates nearest temple
                        VStack(spacing: 8) {
                            ProgressView()
                            Text("Searching for the nearest temple…")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .padding()

                    // No permission - prompt enable location
                    } else {
                        Button {
                            locationAuth.requestAuthorization()
                        } label: {
                            Text("Enable Location to Access This Feature")
                        }
                        .padding()
                    }

                    // Extra enable button area
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
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 1)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                NavigationLink {
                    AllTemplesMapView().padding(.top, 50).ignoresSafeArea(edges: .top)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Browse All Temples")
                            .font(.title2)
                            .bold()
                        HStack(alignment: .center, spacing: 12) {
                            AllTemplesMapView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            Image(systemName: "chevron.right")
                                .font(.headline)
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 1)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onAppear {
                if !locationAuth.canShowUser {
                    locationAuth.requestAuthorization()
                } else if let location = locationAuth.location {
                    mapsVM.getNearestTemple(from: location)
                }
            }
            .onReceive(locationAuth.$location.compactMap { $0 }) { loc in
                mapsVM.getNearestTemple(from: loc)
            }
        }
    }
}

#Preview {
    MapListView()
}
