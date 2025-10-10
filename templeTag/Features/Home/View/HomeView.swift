//
//  HomeView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var templeVM = TemplesViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Home")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.top, 50)
            
            ForEach(0..<3) { _ in
                VStack(alignment: .leading) {
                    Text("Recent News")
                        .font(.title)
                        .bold()
                    ForEach(templeVM.temples) { temple in
                        Text("\(temple.name) was renovated.")
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.tintColor).opacity(0.4))
                .cornerRadius(16)
                
                VStack(alignment: .leading) {
                    Text("Montly Recap")
                        .font(.title)
                        .bold()
                    ForEach(templeVM.temples) { temple in
                        Text("You attended the \(temple.name) temple.")
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.green).opacity(0.4))
                .cornerRadius(16)
                
                VStack(alignment: .leading) {
                    Text("Bucket List")
                        .font(.title)
                        .bold()
                    ForEach(templeVM.temples) { temple in
                        Text("Go to \(temple.name).")
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.red).opacity(0.4))
                .cornerRadius(16)
            }
        }
        .padding(.bottom)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .task {
            await templeVM.load()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
