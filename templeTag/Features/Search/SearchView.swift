//
//  SearchView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var templeVM = TempleViewModel()
    @State private var searchText: String = ""
    @FocusState private var showKeyboard: Bool
    
    var filteredTemples: [Temple] {
        if searchText.isEmpty {
            return templeVM.temples
        } else {
            return templeVM.temples.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Search", text: $searchText)
                    .focused($showKeyboard)

                Button {
                    withAnimation(.easeInOut) {
                        searchText = ""
                        showKeyboard = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color(.systemGray))
                        .font(.title2)
                        .bold()
                        .padding(.vertical, 8)
                }
                .background(Color(.systemGray6).blur(radius: 2))
                .opacity(searchText.isEmpty ? 0 : 1)
                .allowsHitTesting(!searchText.isEmpty)
            }
            .animation(.easeInOut(duration: 0.15), value: !searchText.isEmpty)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            
            if !filteredTemples.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(filteredTemples) { temple in
                            Button {
                                TempleDetailView(temple: temple)
                            } label: {
                                Text(temple.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color(.systemGray))
                                    .padding(.vertical, 4)
                            }
                            
                            if filteredTemples.last != temple {
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.vertical)
                }
                .cornerRadius(16)
                .padding(.top)
            }
            
            Spacer()
        }
        .padding()
        .task {
            await templeVM.load()
        }
    }
}

#Preview {
    SearchView()
}
