//
//  HomeView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var templeVM = TempleViewModel()
    @State private var showAllTemples = false

    // MARK: - Derived data
    private var totalCount: Int { templeVM.temples.count }
    private var dedicatedCount: Int { templeVM.temples.filter { $0.status == .dedicated }.count }
    private var underConstructionCount: Int { templeVM.temples.filter { $0.status == .under_construction }.count }
    private var announcedCount: Int { templeVM.temples.filter { $0.status == .announced }.count }

    private var featured: [Temple] {
        // Prefer items with photos first
        let withPhotos = templeVM.temples.filter { $0.photo != nil }
        return Array((withPhotos.isEmpty ? templeVM.temples : withPhotos).prefix(10))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                stats
                featuredCarousel
                quickActions
                recentSection
                bucketListSection
                Spacer(minLength: 40)
            }
            .padding()
        }
        .task { await templeVM.load() }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Home")
                    .font(.largeTitle).bold()
                Text(Date.now, style: .date)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            Spacer()
        }
    }

    private var stats: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                SummaryStat(title: "Total", value: totalCount, systemImage: "globe.americas.fill")
                SummaryStat(title: "Dedicated", value: dedicatedCount, systemImage: "sparkles")
                SummaryStat(title: "Under Const.", value: underConstructionCount, systemImage: "hammer.fill")
                SummaryStat(title: "Announced", value: announcedCount, systemImage: "megaphone.fill")
            }
            .padding(.vertical, 2)
        }
    }

    private var featuredCarousel: some View {
        HomeSection(title: "Featured Temples", subtitle: "Recently viewed & with photos") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(featured) { temple in
                        TempleCard(temple: temple)
                            .frame(width: 260, height: 180)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private var quickActions: some View {
        HomeSection(title: "Quick Actions") {
            HStack(spacing: 12) {
                Button { showAllTemples = true } label: {
                    Label("All Temples", systemImage: "list.bullet")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button { /* TODO: navigate to map */ } label: {
                    Label("Nearby", systemImage: "mappin.and.ellipse")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button { /* TODO: navigate to goals */ } label: {
                    Label("Goals", systemImage: "target")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .sheet(isPresented: $showAllTemples) {
            // Minimal fallback list if you don't have a dedicated screen yet
            NavigationStack {
                List(templeVM.temples) { t in
                    VStack(alignment: .leading) {
                        Text(t.name).font(.headline)
                        Text(t.city.map { city in
                            t.state.map { "\(city), \($0)" } ?? city
                        } ?? t.country)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    }
                }
                .navigationTitle("All Temples")
            }
        }
    }

    private var recentSection: some View {
        HomeSection(title: "Recent Updates", subtitle: "From your dataset") {
            if templeVM.temples.isEmpty {
                ContentUnavailableView("No data yet", systemImage: "tray")
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(templeVM.temples.prefix(6)) { t in
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: icon(for: t.status))
                                .foregroundStyle(color(for: t.status))
                            Text(recentLine(for: t))
                                .font(.subheadline)
                                .lineLimit(2)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                    }
                }
            }
        }
    }

    private var bucketListSection: some View {
        HomeSection(title: "Bucket List", subtitle: "Your missions & goals") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Create a mission: All Utah Temples")
                Text("Create a mission: All USA Temples")
                Text("Create a mission: All Temples Worldwide")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Helpers
    private func icon(for status: Temple.Status) -> String {
        switch status {
        case .dedicated: return "sparkles"
        case .under_construction: return "hammer.fill"
        case .announced: return "megaphone.fill"
        case .renovation: return "paintbrush"
        case .unknown: return "questionmark.circle"
        }
    }

    private func color(for status: Temple.Status) -> Color {
        switch status {
        case .dedicated: return .green
        case .under_construction: return .orange
        case .announced: return .blue
        case .renovation: return .purple
        case .unknown: return .gray
        }
    }

    private func recentLine(for t: Temple) -> String {
        switch t.status {
        case .dedicated:
            return "\(t.name) is dedicated."
        case .under_construction:
            return "\(t.name) is under construction."
        case .announced:
            return "\(t.name) was announced."
        case .renovation:
            return "\(t.name) is in renovation."
        case .unknown:
            return "Update unknown for \(t.name)."
        }
    }
}

#Preview {
    HomeView()
}

// MARK: - Helper subviews

private struct SummaryStat: View {
    let title: String
    let value: Int
    let systemImage: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: systemImage)
                .imageScale(.large)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text("\(value)").font(.title3).bold()
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct TempleCard: View {
    let temple: Temple

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image
            if let url = temple.photo {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack { Rectangle().fill(.ultraThinMaterial); ProgressView() }
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: Color.gray.opacity(0.2)
                    @unknown default: Color.gray.opacity(0.2)
                    }
                }
            } else {
                LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
            }

            // Overlay
            LinearGradient(colors: [.black.opacity(0.0), .black.opacity(0.55)], startPoint: .center, endPoint: .bottom)

            VStack(alignment: .leading, spacing: 4) {
                Text(temple.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
                Text(temple.city.map { city in
                    temple.state.map { "\(city), \($0)" } ?? city
                } ?? temple.country)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.9))
            }
            .padding(12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(.white.opacity(0.2))
        )
    }
}

private struct HomeSection<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.title3).bold()
                if let subtitle { Text(subtitle).font(.footnote).foregroundStyle(.secondary) }
            }
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
