//
//  Item.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/9/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
