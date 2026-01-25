//
//  EditProfileView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 1/24/26.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: ProfileViewModel
    
    private var hasChanges: Bool {
        false
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // Top bar
                HStack {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    
                    Spacer()
                    
                    Button {
                        let success = vm.saveProfile()
                        success ? dismiss() : ()
                    } label: {
                        Text(hasChanges ? "Save" : "Done")
                    }
                }
                
                // Main view
                VStack {
                    
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
