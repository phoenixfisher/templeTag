//
//  MapsMainView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/10/25.
//

import SwiftUI
import Combine

struct MapsMainView: View {
    @StateObject private var locationAuth = LocationAuth()
    @StateObject private var templeVM = TempleViewModel()
    @StateObject private var mapsVM: MapsViewModel

    init() {
        let tvm = TempleViewModel()
        _templeVM = StateObject(wrappedValue: tvm)
        _mapsVM = StateObject(wrappedValue: MapsViewModel(templeVM: tvm))
    }
    
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
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Nearest Temple")
                        .font(.title2)
                        .bold()

                    // 1) Check permission, then bind nearestTemple safely
                    if locationAuth.canShowUser, let nearest = mapsVM.nearestTemple {
                        let coordinate = nearest.coordinate
                        NavigationLink(destination: ShowOnMap(coordinate: coordinate, label: nearest.name)
                            .padding(.top, 50)
                            .ignoresSafeArea(edges: .top)
                        ) {
                            HStack {
                                Text(nearest.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }

                    // Have permission but no nearest temple yet
                    } else if locationAuth.canShowUser {
                        if mapsVM.isSearchingNearest {
                            HStack {
                                Text("Searching for the nearest temple.")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                ProgressView()
                            }
                        } else if mapsVM.nearestSearchFailed {
                            Text("We couldn’t find a nearby temple.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Button {
                                mapsVM.startNearestSearch(currentLocation: locationAuth.location ?? mapsVM.cachedLocation)
                            } label: {
                                Label("Re-search", systemImage: "arrow.clockwise")
                            }
                        } else {
                            Button {
                                mapsVM.startNearestSearch(currentLocation: locationAuth.location)
                            } label: {
                                Label("Find Nearest Temple", systemImage: "location.magnifyingglass")
                            }
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
                    AllTemplesMapView()
                        .padding(.top, 50)
                        .ignoresSafeArea(edges: .top)
                } label: {
                    HStack {
                        Text("All Temples")
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
                }
                .foregroundStyle(Color(.darkText))
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .shadow(radius: 1)
                
                Spacer()
            }
            .foregroundStyle(Color(.darkText))
            .onAppear {
                Task { await templeVM.load() }
                if !locationAuth.canShowUser {
                    locationAuth.requestAuthorization()
                } else if mapsVM.nearestTemple == nil {
                    mapsVM.startNearestSearch(currentLocation: locationAuth.location)
                }
            }
            .onReceive(locationAuth.$location.compactMap { $0 }) { loc in
                mapsVM.considerLocationUpdate(loc)
            }
        }
        .refreshable {
            await templeVM.load()
            if !locationAuth.canShowUser {
                locationAuth.requestAuthorization()
            } else {
                mapsVM.startNearestSearch(currentLocation: locationAuth.location)
            }
        }
    }
}

#Preview {
    MapsMainView()
}
