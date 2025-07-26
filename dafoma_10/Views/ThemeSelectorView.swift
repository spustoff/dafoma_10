//
//  ThemeSelectorView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct ThemeSelectorView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedThemeIndex: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        themeManager.currentTheme.background,
                        themeManager.currentTheme.accent1.opacity(0.3),
                        themeManager.currentTheme.accent2.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1), value: themeManager.currentThemeIndex)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Choose Your Theme")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Text("Select a color harmony that inspires you")
                                .font(.body)
                                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Theme options
                        LazyVStack(spacing: 24) {
                            ForEach(themeManager.themes.indices, id: \.self) { index in
                                ThemeCard(
                                    theme: themeManager.themes[index],
                                    isSelected: selectedThemeIndex == index,
                                    isCurrentTheme: themeManager.currentThemeIndex == index
                                ) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        selectedThemeIndex = index
                                        themeManager.setTheme(index: index)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Quick preview section
                        PreviewSection()
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("Themes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryButton)
                }
            }
        }
        .onAppear {
            selectedThemeIndex = themeManager.currentThemeIndex
        }
    }
}

struct ThemeCard: View {
    let theme: ThemeSet
    let isSelected: Bool
    let isCurrentTheme: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Theme name and status
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(theme.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        if isCurrentTheme {
                            Text("Current Theme")
                                .font(.caption)
                                .foregroundColor(ColorTheme.primaryButton)
                        }
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(ColorTheme.supportive)
                    }
                }
                
                // Color preview
                HStack(spacing: 8) {
                    ColorPreviewCircle(color: theme.background, label: "BG")
                    ColorPreviewCircle(color: theme.accent1, label: "A1")
                    ColorPreviewCircle(color: theme.accent2, label: "A2")
                    
                    Spacer()
                    
                    ColorPreviewCircle(color: theme.primary, label: "P")
                    ColorPreviewCircle(color: theme.secondary, label: "S")
                }
                
                // Sample interface preview
                SampleInterfacePreview(theme: theme)
            }
            .padding(20)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorPreviewCircle: View {
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 32, height: 32)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(ColorTheme.primaryText.opacity(0.6))
        }
    }
}

struct SampleInterfacePreview: View {
    let theme: ThemeSet
    
    var body: some View {
        VStack(spacing: 8) {
            // Sample header
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(theme.primary)
                    .frame(width: 60, height: 8)
                
                Spacer()
                
                Circle()
                    .fill(theme.secondary)
                    .frame(width: 16, height: 16)
            }
            
            // Sample content
            VStack(spacing: 4) {
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.accent1)
                        .frame(width: 100, height: 6)
                    
                    Spacer()
                }
                
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.accent2)
                        .frame(width: 80, height: 6)
                    
                    Spacer()
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.background.opacity(0.3))
        )
    }
}

struct PreviewSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Live Preview")
                .font(.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                // Sample buttons
                HStack(spacing: 12) {
                    CustomButton(
                        title: "Primary",
                        action: {},
                        style: .primary,
                        size: .small
                    )
                    
                    CustomButton(
                        title: "Secondary",
                        action: {},
                        style: .secondary,
                        size: .small
                    )
                }
                
                // Sample task item
                HStack {
                    Circle()
                        .fill(themeManager.currentTheme.primary)
                        .frame(width: 12, height: 12)
                    
                    Text("Sample task item")
                        .font(.body)
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Text("High")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(themeManager.currentTheme.secondary)
                        )
                        .foregroundColor(ColorTheme.primaryText)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.neutral.opacity(0.1))
                )
            }
        }
        .padding(20)
    }
}

struct ThemeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelectorView()
            .environmentObject(ThemeManager())
    }
} 
