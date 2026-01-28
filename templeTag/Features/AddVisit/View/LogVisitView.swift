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
    
    @State private var newCompanionName: String = ""
    @State private var newNote: String = ""
    
    private var validForm: Bool {
        selectedTemple != nil && selectedOrdinances.count > 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
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
                        .shadow(radius: 1)
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
                            .shadow(radius: 1)
                        }
                        .sheet(isPresented: $showDateTimePicker) {
                            DateTimePicker(date: $date, time: $time)
                                .presentationDetents([.medium, .large])
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
                                    .shadow(radius: 1)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16).stroke(isSelected ? Color(.tintColor) : .clear, lineWidth: isSelected ? 2 : 0)
                                    )
                                }
                            }
                        }
                    }
                    
                    // Add companions
                    VStack(alignment: .leading) {
                        Text("Companions")
                            .font(.headline)
                        TextField("Add someone to this visit", text: $newCompanionName)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .textFieldStyle(.plain)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled(false)
                            .submitLabel(.done)
                    }
                    
                    // Add notes
                    VStack(alignment: .leading) {
                        Text("Notes")
                            .font(.headline)
                        TextField("Describe your visit here", text: $newNote)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .textFieldStyle(.plain)
                            .textInputAutocapitalization(.sentences)
                            .autocorrectionDisabled(false)
                            .submitLabel(.done)
                    }
                    
                    Button {
                        if vm.logVisit() {
                            // TODO: Clear form and return to a different tab?
                        } else {
                            // TODO: Toast message
                        }
                    } label: {
                        Text("Log Temple Visit")
                            .font(.title2.weight(.medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!validForm)
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
