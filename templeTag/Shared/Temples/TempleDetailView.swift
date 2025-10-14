//
//  TempleDetailView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI

struct TempleDetailView: View {
    @StateObject private var templeVM = TempleViewModel()
    let temple: Temple

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Photo
                if let url = temple.photo {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Rectangle().fill(.ultraThinMaterial)
                                ProgressView()
                            }
                            .frame(maxWidth: .infinity, minHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, minHeight: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .accessibilityLabel(temple.photoCaption ?? "\(temple.name) photo")
                        case .failure:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, minHeight: 220)
                                .foregroundStyle(.secondary)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        @unknown default:
                            EmptyView()
                        }
                    }

                    if let credit = temple.photoCredit, !credit.isEmpty {
                        Text("Photo: \(credit)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                // Title + status
                VStack(alignment: .leading, spacing: 8) {
                    Text(temple.name)
                        .font(.title)
                        .bold()
                        .accessibilityAddTraits(.isHeader)

                    HStack(spacing: 8) {
                        StatusBadge(status: temple.status)
                        if let city = temple.city, let state = temple.state {
                            Label("\(city), \(state)", systemImage: "mappin.and.ellipse")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else if let city = temple.city {
                            Label(city, systemImage: "mappin.and.ellipse")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // Address (if present)
                if let address = temple.address, !address.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Address")
                            .font(.headline)
                        Text(address)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .textSelection(.enabled)
                    }
                }

                // Links
                if temple.website != nil || temple.appointments != nil {
                    HStack {
                        if let url = temple.website {
                            Link(destination: url) {
                                Label("Website", systemImage: "safari")
                            }
                            .buttonStyle(.bordered)
                        }
                        if let url = temple.appointments {
                            Link(destination: url) {
                                Label("Appointments", systemImage: "calendar.badge.clock")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                // Map
                ShowOnMap(coordinate: temple.coordinate, label: temple.name)
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityHidden(true)

                // Description
                if let desc = temple.description, !desc.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                        Text(desc)
                            .font(.body)
                    }
                }

                // Meta
                VStack(alignment: .leading, spacing: 4) {
                    Text("Country: \(temple.country)")
                    Text(String(format: "Lat: %.5f, Lng: %.5f", temple.latitude, temple.longitude))
                        .foregroundStyle(.secondary)
                    Text("Updated: \(temple.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                .font(.subheadline)

            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Status Badge

private struct StatusBadge: View {
    let status: Temple.Status

    var body: some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(background)
            .foregroundStyle(foreground)
            .clipShape(Capsule())
            .accessibilityLabel("Status: \(label)")
    }

    private var label: String {
        switch status {
        case .dedicated: return "Dedicated"
        case .under_construction: return "Under Construction"
        case .announced: return "Announced"
        case .renovation: return "Renovation"
        case .unknown: return "Unknown"
        }
    }

    private var background: Color {
        switch status {
        case .dedicated: return Color.green.opacity(0.15)
        case .under_construction: return Color.orange.opacity(0.15)
        case .announced: return Color.blue.opacity(0.15)
        case .renovation: return Color.purple.opacity(0.15)
        case .unknown: return Color.gray.opacity(0.15)
        }
    }

    private var foreground: Color {
        switch status {
        case .dedicated: return .green
        case .under_construction: return .orange
        case .announced: return .blue
        case .renovation: return .purple
        case .unknown: return .gray
        }
    }
}
