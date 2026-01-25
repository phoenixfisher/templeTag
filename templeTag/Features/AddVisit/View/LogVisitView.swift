//
//  LogVisitView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 1/22/26.
//

import SwiftUI

struct LogVisitView: View {
    // TODO: might have to rethink this logic.
    @StateObject private var templeVM = TempleViewModel()
    
    @State private var selectedTemple: String? = nil
    @State private var selectedOrdinances: [Ordinance] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Select a temple
                    VStack(alignment: .leading) {
                        Text("Temple")
                            .font(.headline)
                        Picker("Temple", selection: $selectedTemple) {
                            Text("Select a temple").tag(nil as String?)
                            ForEach(templeVM.temples, id: \.self) { temple in
                                Text(temple.name)
                                    .tag(temple)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 60)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .foregroundStyle(.primary)
                    }
                    
                    // Select a date
                    VStack {
                        Text("Date")
                            .font(.headline)
                    }
                    
                    // Select an ordinance
                    VStack(alignment: .leading) {
                        Text("Ordinance (Optional)")
                            .font(.headline)

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(Ordinance.allCases, id: \.self) { type in
                                let isSelected = selectedOrdinances.contains(type)

                                Button {
                                    if let idx = selectedOrdinances.firstIndex(of: type) {
                                        selectedOrdinances.remove(at: idx)
                                    } else {
                                        selectedOrdinances.append(type)
                                    }
                                } label: {
                                    VStack(spacing: 8) {
                                        Text(type.emoji)
                                            .font(.title3)

                                        Text(type.rawValue)
                                            .font(.headline)
                                            .foregroundStyle(isSelected ? .white : .primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16).fill(isSelected ? AnyShapeStyle(Color(.tintColor)) : AnyShapeStyle(.thinMaterial))
                                    )
                                }
                            }
                        }
                    }
                    
                    // Add a time
                    VStack {
                        Text("Session Time (Optional)")
                            .font(.headline)
                    }
                    
                    // Add companions
                    VStack {
                        Text("Companions (Optional)")
                            .font(.headline)
                    }
                    
                    VStack {
                        Text("Notes (Optional)")
                            .font(.headline)
                    }
                }
                .padding()
            }
            .task {
                if templeVM.temples.isEmpty {
                    await templeVM.load()
                }
            }
            .navigationTitle("Log Visit")
        }
    }
}
