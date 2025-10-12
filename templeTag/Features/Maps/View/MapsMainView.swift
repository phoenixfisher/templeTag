//
//  MapsMainView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/10/25.
//

import SwiftUI
import Combine

struct MapsMainView: View {
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
<<<<<<< HEAD:templeTag/Features/Maps/View/MapsMainView.swift
                        if mapsVM.isSearchingNearest {
                            VStack(spacing: 8) {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text("Searching for the nearest temple…")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                        } else if mapsVM.nearestSearchFailed {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Something went wrong. Couldn't find a nearby temple")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                Button {
                                    withAnimation(.easeInOut) {
                                        mapsVM.startNearestSearch(currentLocation: locationAuth.location)
                                    }
                                } label: {
                                    Text("Try Again")
                                    Image(systemName: "arrow.clockwise")
                                }
                            }
                        } else {
                            Button {
                                mapsVM.startNearestSearch(currentLocation: locationAuth.location)
                            } label: {
                                Text("Find Nearest Temple")
                                Image(systemName: "location.magnifyingglass")
                            }
=======
                        HStack {
                            Text("Searching for the nearest temple")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            ProgressView()
>>>>>>> main:templeTag/Features/Maps/View/MapListView.swift
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
<<<<<<< HEAD:templeTag/Features/Maps/View/MapsMainView.swift
                
                NavigationLink(destination: AllTemplesMapView().padding(.top, 50).ignoresSafeArea(edges: .top)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Browse All Temples")
                            .font(.title2)
=======
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
>>>>>>> main:templeTag/Features/Maps/View/MapListView.swift
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "chevron.right")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
<<<<<<< HEAD:templeTag/Features/Maps/View/MapsMainView.swift
=======
                .foregroundStyle(Color(.darkText))
                .padding(.horizontal)
>>>>>>> main:templeTag/Features/Maps/View/MapListView.swift
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(Color(.darkText))
            .onAppear {
                if !locationAuth.canShowUser {
                    locationAuth.requestAuthorization()
                } else if mapsVM.nearestTemple == nil {
                    mapsVM.startNearestSearch(currentLocation: locationAuth.location)
                }
            }
            .onReceive(locationAuth.$location.compactMap { $0 }) { loc in
                mapsVM.startNearestSearch(currentLocation: loc)
            }
        }
        .padding()
    }
}

#Preview {
    MapsMainView()
}
