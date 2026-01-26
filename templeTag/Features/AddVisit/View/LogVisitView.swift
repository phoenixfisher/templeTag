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
    @StateObject private var vm = VisitViewModel()
    
    @State private var date: Date = Date()
    @State private var time: Date? = nil
    @State private var showDateTimePicker: Bool = false
    
    @State private var selectedTemple: String? = nil
    @State private var selectedOrdinances: [Ordinance] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Select a temple
                    // TODO: Make a typing selector of some sort
                    VStack(alignment: .leading) {
                        Text("Temple")
                            .font(.headline)
                        Picker("Temple", selection: $selectedTemple) {
                            Text("Select a temple").tag(nil as String?)
                            ForEach(templeVM.temples, id: \.self) { temple in
                                Text(temple.name).tag(temple.name as String?)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(radius: 2)
                    }
                    
                    // Select a date
                    VStack(alignment: .leading) {
                        Text("Date")
                            .font(.headline)
                        Button {
                            showDateTimePicker = true
                        } label: {
                            HStack {
                                Image(systemName: "calendar")
                                Text(date.formatted(date: .abbreviated, time: time == nil ? .omitted : .shortened))
                                Spacer()
                            }
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(radius: 2)
                        }
                        .sheet(isPresented: $showDateTimePicker) {
                            DateTimePicker(date: $date, time: $time)
                        }
                    }

                    
                    // Select an ordinance
                    VStack(alignment: .leading) {
                        Text("Ordinance")
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
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16).fill(isSelected ? AnyShapeStyle(Color(.tintColor).opacity(0.4)) : AnyShapeStyle(.thinMaterial))
                                    )
                                    .shadow(radius: 2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16).stroke(isSelected ? Color(.tintColor) : .clear, lineWidth: isSelected ? 2 : 0)
                                    )
                                }
                            }
                        }
                    }
                    
                    // Add companions
                    VStack {
                        Text("Companions")
                            .font(.headline)
                    }
                    
                    VStack {
                        Text("Notes")
                            .font(.headline)
                    }
                    
                    Button {
                        if vm.logVisit() {
                            // TODO: Clear form and return to a different tab?
                        } else {
                            // TODO: Toast message
                        }
                    } label: {
                        Text("Save Visit")
                            .font(.title2.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .background(Color(.tintColor))
                            .cornerRadius(16)
                            .foregroundStyle(.white)
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
