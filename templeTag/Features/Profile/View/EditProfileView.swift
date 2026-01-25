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
            VStack(alignment: .center, spacing: 12) {
                
                // MARK: Profile photo
                Avatar(image: vm.avatar)
                
                Button("Change Photo") {
                    vm.onChangePhoto?()
                }
                
                // MARK: Identifying information
                Text("Personal Information")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0) {
                    SettingRow(title: "Full Name", detail: vm.displayName) {
                        
                    }
                    Divider()
                    SettingRow(title: "Email", detail: vm.displayName) {
                        
                    }
                    Divider()
                    SettingRow(title: "Phone Number", detail: vm.displayName) {
                        
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 4)
                )
                
                // MARK: Church info
                Text("Church Information")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0) {
                    SettingRow(title: "Ward", detail: vm.displayName) {
                        
                    }
                    Divider()
                    SettingRow(title: "Stake", detail: vm.displayName) {
                        
                    }
                    Divider()
                    SettingRow(title: "Home Temple", detail: vm.homeTemple) {
                        
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 4)
                )
                
                // MARK: Settings
                Text("Settings")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0) {
                    SettingRow(title: "Ward", detail: vm.displayName) {
                        
                    }
                    Divider()
                    SettingRow(title: "Stake", detail: vm.displayName) {
                        
                    }
                    Divider()
                    SettingRow(title: "Home Temple", detail: vm.homeTemple) {
                        
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 4)
                )
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(hasChanges ? "Save" : "Done") {
                    if hasChanges {
                        if vm.saveProfile() {
                            dismiss()
                        }
                    } else {
                        dismiss()
                    }
                }
            }
        }
    }
}
