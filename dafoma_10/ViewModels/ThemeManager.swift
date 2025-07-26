//
//  ThemeManager.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var currentThemeIndex: Int = 0
    @Published var isDarkMode: Bool = false
    
    let themes: [ThemeSet] = [
        ThemeSet(
            name: "Ocean Harmony",
            background: ColorTheme.backgroundMain,
            accent1: ColorTheme.backgroundAccent1,
            accent2: ColorTheme.backgroundAccent2,
            primary: ColorTheme.primaryButton,
            secondary: ColorTheme.secondaryButton
        ),
        ThemeSet(
            name: "Sunset Vibes",
            background: ColorTheme.primaryButton,
            accent1: ColorTheme.secondaryButton,
            accent2: ColorTheme.backgroundAccent1,
            primary: ColorTheme.backgroundMain,
            secondary: ColorTheme.backgroundAccent2
        ),
        ThemeSet(
            name: "Night Mode",
            background: ColorTheme.backgroundAccent2,
            accent1: ColorTheme.backgroundAccent1,
            accent2: ColorTheme.backgroundMain,
            primary: ColorTheme.supportive,
            secondary: ColorTheme.primaryButton
        )
    ]
    
    var currentTheme: ThemeSet {
        themes[currentThemeIndex]
    }
    
    func nextTheme() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentThemeIndex = (currentThemeIndex + 1) % themes.count
        }
    }
    
    func setTheme(index: Int) {
        guard index < themes.count else { return }
        withAnimation(.easeInOut(duration: 0.5)) {
            currentThemeIndex = index
        }
    }
}

struct ThemeSet {
    let name: String
    let background: Color
    let accent1: Color
    let accent2: Color
    let primary: Color
    let secondary: Color
} 