//
//  Goal.swift
//  templeTag
//
//  Created by Phoenix Fisher on 1/22/26.
//

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
