//
//  ButtonStyle.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/12.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct SelectButtonStyle: ButtonStyle {
    var isSelected: Bool
    var color: Color = .appNavBarButtonColor
    var disabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isSelected ? .white : color)
            .padding()
            .background(isSelected ? color : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .disabled(disabled)
            .opacity(disabled ? 0.7 : 1.0)
    }
}

struct ButtonPrimaryStyle: ButtonStyle {
    var disabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.appSpecialRed)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appSpecialRed, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .disabled(disabled)
            .opacity(disabled ? 0.7 : 1.0)
    }
}

struct ButtonSecondaryStyle: ButtonStyle {
    var disabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.appSpecialRed)
            .padding()
            .background(Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appSpecialRed, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .disabled(disabled)
            .opacity(disabled ? 0.7 : 1.0)
    }
}

struct ButtonTertiaryStyle: ButtonStyle {
    var disabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.appSpecialRed)
            .padding()
            .background(Color.clear)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .disabled(disabled)
            .opacity(disabled ? 0.7 : 1.0)
    }
}

extension View {
    func addPrimaryButtonStyle() -> some View {
        modifier(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(Color.appSpecialRed)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appSpecialRed, lineWidth: 1)
            )
    }
}
