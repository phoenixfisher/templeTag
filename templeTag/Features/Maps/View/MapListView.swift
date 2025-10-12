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
                HStack {
                    Text("Maps")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Nearest Temple")
                        .font(.title2)
                        .bold()

                    // 1) Check permission, then bind nearestTemple safely
                    if locationAuth.canShowUser, let nearest = mapsVM.nearestTemple {
                        let coordinate = nearest.coordinate
                        NavigationLink(destination: ShowOnMap(coordinate: coordinate, label: nearest.name)) {
                            HStack {
                                ShowOnMap(coordinate: coordinate, label: nearest.name).padding(.top, 50).ignoresSafeArea(edges: .top)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 160)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))

                                Text("View Temple Nearest to Me")
                                Image(systemName: "chevron.right")
                            }
                        }

                    // Have permission but no nearest temple yet
                    } else if locationAuth.canShowUser {
                        HStack {
                            Text("Searching for the nearest temple")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            ProgressView()
                        }

                    // No permission - prompt enable location
                    } else {
                        Button {
                            locationAuth.requestAuthorization()
                        } label: {
                            Text("Enable Location to Access This Feature")
                        }
                    }

                    // Extra enable button area
                    if !locationAuth.canShowUser {
                        Button {
                            locationAuth.requestAuthorization()
                        } label: {
                            Text("Enable Location")
                            Image(systemName: "location.circle")
                        }
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 1)
                .padding()
                
                NavigationLink {
                    AllTemplesMapView().padding(.top, 50).ignoresSafeArea(edges: .top)
                } label: {
                    HStack {
                        Text("Map Showing All Temples")
                            .font(.title2)
                            .bold()
                        Spacer()
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "chevron.right")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 1)
                }
                .foregroundStyle(Color(.darkText))
                .padding(.horizontal)
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
