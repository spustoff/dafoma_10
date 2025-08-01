//
//  ColorTheme.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct ColorTheme {
    // Background Colors
    static let backgroundMain = Color(hex: "#2490ad")
    static let backgroundAccent1 = Color(hex: "#3c166d")
    static let backgroundAccent2 = Color(hex: "#1a2962")
    
    // Button Colors
    static let primaryButton = Color(hex: "#fbaa1a")
    static let secondaryButton = Color(hex: "#f0048d")
    
    // Additional Colors
    static let supportive = Color(hex: "#01ff00")
    static let neutral = Color(hex: "#f7f7f7")
    
    // Text Colors for contrast
    static let primaryText = Color.white
    static let secondaryText = Color.black
}

// Extension to support hex color initialization
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 