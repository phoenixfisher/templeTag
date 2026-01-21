//
//  ViewComponents.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/13/25.
//

import SwiftUI

// Picture or initials card
struct Avatar: View {
    var image: Image?
    
    var body: some View {
        ZStack {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.fill")
            }
        }
        .clipShape(Circle())
        .shadow(radius: 3, y: 1)
    }
}

// Section headers as potential
struct SectionHeader: View {
    var title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.subheadline.weight(.semibold))
            }
        }
        .padding(.horizontal, 4)
    }
}

// Base info card on profile page
struct StatCard: View {
    var title: String
    var value: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.semibold))
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .shadow(radius: 2, y: 1)
        )
    }
}

// Small lightly shaded capsule card. Used for current goal
struct TagChip: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.thinMaterial, in: Capsule())
    }
}

struct ProgressRing: View {
    var progress: CGFloat // 0...1
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(.quaternary, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Circle()
                .trim(from: 0, to: max(0.001, progress))
                .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.smooth(duration: 0.6), value: progress)
                .foregroundStyle(Color(.accent))
            Text("\(Int(progress * 100))%")
                .font(.headline)
                .foregroundStyle(Color(.accent))
        }
        .padding(6)
    }
}

// Cards with no data
struct EmptyState: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.quaternary, lineWidth: 1)
            )
    }
}

// Cards for achievements or earned badges. Only shows up when there are completed badges
struct BadgeCard: View {
    let badge: Badge
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: badge.icon)
                .font(.title2)
                .padding(12)
                .background(.thinMaterial, in: Circle())
            Text(badge.title)
                .font(.footnote.weight(.semibold))
                .multilineTextAlignment(.center)
            Text(badge.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .shadow(radius: 3, y: 2)
        )
    }
}

// Row outline for mutable settings
struct SettingRow: View {
    var icon: String
    var title: String
    var detail: String?
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .frame(width: 28, height: 28)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                Text(title)
                    .font(.body)
                Spacer()
                if let detail {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
        }
        .buttonStyle(.plain)
    }
}
