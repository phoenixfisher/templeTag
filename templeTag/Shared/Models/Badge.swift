//
//  Badge.swift
//  templeTag
//
//  Created by Phoenix Fisher on 1/22/26.
//

import Foundation

struct Badge: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
}
