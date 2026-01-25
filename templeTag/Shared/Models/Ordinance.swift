//
//  Ordinance.swift
//  templeTag
//
//  Created by Phoenix Fisher on 1/24/26.
//

enum Ordinance: String, CaseIterable, Identifiable {
    case endowment = "Endowment"
    case sealing = "Sealing"
    case baptisms = "Baptisms"
    case initiatory = "Initiatory"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .endowment: return "🙏"
        case .sealing: return "💍"
        case .baptisms: return "💧"
        case .initiatory: return "✨"
        }
    }
}
