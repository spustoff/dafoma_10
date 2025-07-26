//
//  OnboardingView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    @State private var showAnimation = false
    
    let onboardingPages = [
        OnboardingPage(
            title: "Welcome to ColorHarmony",
            subtitle: "Discover the power of beautiful color combinations",
            imageName: "paintpalette.fill",
            description: "Create stunning visual harmony with our carefully curated color themes designed for productivity and creativity."
        ),
        OnboardingPage(
            title: "Dynamic Themes",
            subtitle: "Switch between beautiful color schemes",
            imageName: "eye.fill",
            description: "Experience seamless theme transitions that adapt to your mood and enhance your workflow throughout the day."
        ),
        OnboardingPage(
            title: "Boost Productivity",
            subtitle: "Organize tasks with visual elegance",
            imageName: "checkmark.seal.fill",
            description: "Manage your tasks, set priorities, and track progress with an interface that motivates and inspires action."
        ),
        OnboardingPage(
            title: "Ready to Begin",
            subtitle: "Let's create something beautiful together",
            imageName: "sparkles",
            description: "Your journey to enhanced productivity and visual delight starts now. Welcome to ColorHarmony: Blink!"
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated background
                LinearGradient(
                    colors: [
                        themeManager.currentTheme.background,
                        themeManager.currentTheme.accent1,
                        themeManager.currentTheme.accent2
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .hueRotation(.degrees(showAnimation ? 30 : 0))
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: showAnimation)
                
                VStack(spacing: 0) {
                    // Page content
                    TabView(selection: $currentPage) {
                        ForEach(onboardingPages.indices, id: \.self) { index in
                            OnboardingPageView(
                                page: onboardingPages[index],
                                isAnimating: showAnimation
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: geometry.size.height * 0.7)
                    
                    // Bottom section
                    VStack(spacing: 24) {
                        // Page indicator
                        HStack(spacing: 8) {
                            ForEach(0..<onboardingPages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? ColorTheme.primaryButton : ColorTheme.neutral.opacity(0.5))
                                    .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                            }
                        }
                        
                        // Navigation buttons
                        HStack(spacing: 16) {
                            if currentPage > 0 {
                                CustomButton(
                                    title: "Previous",
                                    action: previousPage,
                                    style: .neutral,
                                    size: .medium
                                )
                            }
                            
                            Spacer()
                            
                            CustomButton(
                                title: currentPage == onboardingPages.count - 1 ? "Get Started" : "Next",
                                action: currentPage == onboardingPages.count - 1 ? completeOnboarding : nextPage,
                                style: currentPage == onboardingPages.count - 1 ? .secondary : .primary,
                                size: .large
                            )
                        }
                        .padding(.horizontal, 32)
                        
                        // Skip button
                        if currentPage < onboardingPages.count - 1 {
                            Button("Skip") {
                                completeOnboarding()
                            }
                            .foregroundColor(ColorTheme.neutral)
                            .font(.footnote)
                        }
                    }
                    .frame(height: geometry.size.height * 0.3)
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            showAnimation = true
            // Start theme rotation for demo
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
                themeManager.nextTheme()
            }
        }
    }
    
    private func nextPage() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentPage = min(currentPage + 1, onboardingPages.count - 1)
        }
    }
    
    private func previousPage() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentPage = max(currentPage - 1, 0)
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            hasSeenOnboarding = true
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isAnimating: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(ColorTheme.primaryButton)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            
            VStack(spacing: 16) {
                // Title
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                
                // Subtitle
                Text(page.subtitle)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                // Description
                Text(page.description)
                    .font(.body)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // Theme preview
            HStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(themeManager.themes[index].primary)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(
                                    themeManager.currentThemeIndex == index ? ColorTheme.neutral : Color.clear,
                                    lineWidth: 2
                                )
                        )
                        .scaleEffect(themeManager.currentThemeIndex == index ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: themeManager.currentThemeIndex)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
    let description: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(ThemeManager())
    }
} 