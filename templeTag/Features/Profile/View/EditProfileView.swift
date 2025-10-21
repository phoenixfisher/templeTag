//
//  EditProfileView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/20/25.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    
    let userId: String

    var body: some View {
        Form {
            Section(header: Text("Photo")) {
                VStack(spacing: 12) {
                    ProfilePhotoView(userId: userId, userInitials: vm.initials)
                        .frame(maxWidth: .infinity)
                        .listRowInsets(EdgeInsets())
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            Section(header: Text("Profile")) {
                TextField("Display Name", text: $vm.editDraft.displayName)
                TextField("Home Temple", text: $vm.editDraft.homeTemple)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { vm.isEditing = false }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { vm.applyDraft() }
                    .disabled(vm.editDraft.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}
