//
//  ProfilePhotoView.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/21/25.
//

import SwiftUI
import PhotosUI

struct ProfilePhotoView: View {
    @StateObject private var vm = ProfilePhotoViewModel()
    
    let userId: String
    let userInitials: String
    
    @State private var showSource = false
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @State private var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Avatar circle
                Avatar(initials: userInitials, image: vm.uiImage.map { Image(uiImage: $0) })
                    .frame(width: 120, height: 120)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showSource = true
                        } label: {
                            Image(systemName: "pencil")
                                .imageScale(.small)
                                .padding(8)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .padding(4)
                    }
                }
                .frame(width: 120, height: 120)
            }
            
            HStack(spacing: 12) {
                Button("Save") {
                    try? vm.saveLocally(userId: userId)
                }
                .buttonStyle(.bordered)
                
                // TODO: Implement functionality
//                Button {
//                    Task { await vm.upload(userId: userId) }
//                } label: {
//                    if vm.isUploading {
//                        ProgressView()
//                    } else {
//                        Text("Upload")
//                    }
//                }
//                .buttonStyle(.borderedProminent)
//                .disabled(vm.uiImage == nil || vm.isUploading)
            }
            
            if let err = vm.error {
                Text(err).foregroundStyle(.red)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        // PhotosPicker (iOS17+)
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $photosPickerItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: photosPickerItem) { _, photo in
            guard let photo else { return }
            Task {
                // Load image data first (works for HEIC/JPEG/PNG). Fallback to URL if needed.
                if let data = try? await photo.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    vm.setNewImage(img)
                } else if let url = try? await photo.loadTransferable(type: URL.self),
                          let data = try? Data(contentsOf: url),
                          let img = UIImage(data: data) {
                    vm.setNewImage(img)
                }
            }
        }
        .confirmationDialog(
            "Change profile photo",
            isPresented: $showSource,
            titleVisibility: .visible
        ) {
            Button("Choose from Photos") { showPhotoPicker = true }
            Button("Take Photo") { showCamera = true }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker { image in
                if let image = image { vm.setNewImage(image) }
            }
            .ignoresSafeArea()
        }
        .navigationTitle("Edit Profile Photo")
        .task {
            if let data = try? LocalAvatarStore.shared.loadAvatarJPEG(userId: userId), let img = UIImage(data: data) {
                vm.uiImage = img
            }
        }
    }
}
