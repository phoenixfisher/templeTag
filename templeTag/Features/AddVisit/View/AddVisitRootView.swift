//
//  AddVisitRootView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 1/22/26.
//

import SwiftUI

struct AddVisitRootView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    RecordVisit()
                } label: {
                    Text("Record a Visit")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 300, height: 300)
                        .background(.blue)
                        .cornerRadius(20)
                }
                .padding()

                NavigationLink {
                    PlanVisitView()
                } label: {
                    Text("Plan Your Next Visit")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 300, height: 300)
                        .background(.green)
                        .cornerRadius(20)
                }
                .padding()
            }
            .foregroundStyle(.white)
        }
    }
}
