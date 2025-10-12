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
        VStack(alignment: .leading, spacing: 10) {
            Image("ColoredTempleIcon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color(.tintColor), lineWidth: 4)
                )
                .frame(maxWidth: .infinity, alignment: .center)
            
            if let temple = temple {
                HStack {
                    Text("Name:")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(temple.name)
                }
                HStack {
                    Text("Location:")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(temple.country)
                }
            }
            
            if let coordinate = temple?.coordinate, let label = temple?.name {
                ShowOnMap(coordinate: coordinate, label: label)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(16)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .task {
            await templeVM.load()
        }
    }
}

