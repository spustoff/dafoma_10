//
//  CustomButton.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var style: ButtonStyle = .primary
    var size: ButtonSize = .medium
    var isEnabled: Bool = true
    
    enum ButtonStyle {
        case primary, secondary, accent, neutral
        
        var backgroundColor: Color {
            switch self {
            case .primary: return ColorTheme.primaryButton
            case .secondary: return ColorTheme.secondaryButton
            case .accent: return ColorTheme.backgroundAccent1
            case .neutral: return ColorTheme.neutral
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary, .secondary, .accent: return ColorTheme.primaryText
            case .neutral: return ColorTheme.secondaryText
            }
        }
    }
    
    enum ButtonSize {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium: return EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
            case .large: return EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32)
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 16
            case .large: return 18
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: size.fontSize, weight: .semibold))
                .foregroundColor(style.textColor)
                .padding(size.padding)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(style.backgroundColor)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .scaleEffect(isEnabled ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CustomButton(title: "Primary Button", action: {})
            CustomButton(title: "Secondary Button", action: {}, style: .secondary)
            CustomButton(title: "Accent Button", action: {}, style: .accent)
            CustomButton(title: "Large Button", action: {}, size: .large)
            CustomButton(title: "Disabled Button", action: {}, isEnabled: false)
        }
        .padding()
        .background(ColorTheme.backgroundMain)
    }
} 