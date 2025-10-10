//
//  TempleDetailView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI

struct TempleDetailView: View {
    @StateObject private var templeVM = TempleViewModel()
    var temple: Temple? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "temple")
                .frame(width: 100, height: 100)
                .padding()
                .cornerRadius(16)
            
            if let temple = temple {
                Text("Name: \(temple.name)")
                Text("Location: \(temple.country)")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .task {
            await templeVM.load()
        }
    }
}
