//
//  ColorHarmonyApp.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

@main
struct ColorHarmonyApp: App {
    @StateObject private var themeManager = ThemeManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environmentObject(themeManager)
            } else {
                OnboardingView()
                    .environmentObject(themeManager)
            }
        }
    }
} 