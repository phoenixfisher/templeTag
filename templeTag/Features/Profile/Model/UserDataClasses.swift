//
//  UserDataClasses.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/13/25.
//

import Foundation

struct Visit: Identifiable, Hashable {
    let id = UUID()
    let templeName: String
    let date: Date
    let note: String?
}

struct Badge: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
}

enum DefaultView: String, CaseIterable {
    case map = "Map"
    case list = "List"
}

struct Goal: Hashable {
    var label: String
    var current: Int
    var target: Int
    var progress: Double {
        guard target > 0 else { return 0 }
        return min(1, Double(current) / Double(target))
    }
    var progressString: String { "\(current)/\(target)" }
}
