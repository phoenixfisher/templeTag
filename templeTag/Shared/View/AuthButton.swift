//
//  AuthButton.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/19/25.
//

import SwiftUI

struct AuthButton: ButtonStyle {
    var outlined: Bool = false
    var font: Font = .title3
    var tint: Color = Color(white: 0.25)
    var textColor: Color = .white
    var radius: CGFloat = 16
    var lineWidth: CGFloat = 3
    var minHeight: CGFloat = 52

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(outlined ? .clear : tint)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(
                        outlined ? tint : .primary.opacity(0.08),
                        lineWidth: outlined ? lineWidth : 1
                    )
            )
            .foregroundStyle(textColor)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
