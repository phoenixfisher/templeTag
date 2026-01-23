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
