//
//  ProfilePhotoViewModel.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/21/25.
//

import SwiftUI
import PhotosUI
import Combine

@MainActor
final class ProfilePhotoViewModel: ObservableObject {
    @Published var uiImage: UIImage?
    @Published var isUploading: Bool = false
    @Published var error: String?
    
    func setNewImage(_ image: UIImage) {
        // Center, crop, and downsize to manageable dimensions
        let squared = image.centerCroppedSquare()
        let downsized = squared.downsized(maxDimension: 512)
        self.uiImage = downsized
    }
    
    func saveLocally(userId: String) throws {
        guard let data = uiImage?.jpegData(compressionQuality: 0.9) else { return }
        try LocalAvatarStore.shared.saveAvatarJPEG(data: data, userId: userId)
    }
    
    // TODO: Update to db
//    func upload(userId: String) async {
//        guard let data = uiImage?.jpegData(compressionQuality: 0.9) else { return }
//        isUploading = true
//        defer { isUploading = false }
//        do {
//            try await Task.sleep(nanoseconds: 400_000_000)
//        } catch {
//            self.error = error.localizedDescription
//        }
//    }
}
