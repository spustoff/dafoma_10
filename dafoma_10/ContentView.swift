//
//  ContentView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var taskManager = TaskManager()
    @State private var selectedTab = 0
    @State private var showingAddTask = false
    @State private var showingThemeSelector = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dynamic background
                LinearGradient(
                    colors: [
                        themeManager.currentTheme.background,
                        themeManager.currentTheme.accent1.opacity(0.3),
                        themeManager.currentTheme.background
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HeaderView(
                        showingThemeSelector: $showingThemeSelector,
                        showingAddTask: $showingAddTask
                    )
                    
                    // Tab content
                    TabView(selection: $selectedTab) {
                        // Dashboard Tab
                        DashboardView()
                            .environmentObject(taskManager)
                            .tag(0)
                        
                        // Tasks Tab
                        TasksView(showingAddTask: $showingAddTask)
                            .environmentObject(taskManager)
                            .tag(1)
                        
                        // Colors Tab
                        ColorsView()
                            .tag(2)
                        
                        // Settings Tab
                        SettingsView()
                            .tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom Tab Bar
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
                .environmentObject(taskManager)
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showingThemeSelector) {
            ThemeSelectorView()
                .environmentObject(themeManager)
        }
    }
}

struct HeaderView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showingThemeSelector: Bool
    @Binding var showingAddTask: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("ColorHarmony")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(themeManager.currentTheme.name)
                    .font(.caption)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Add task button
                Button {
                    showingAddTask = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryButton)
                }
                
                // Theme selector button
                Button {
                    showingThemeSelector = true
                } label: {
                    Circle()
                        .fill(themeManager.currentTheme.primary)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(ColorTheme.primaryText, lineWidth: 2)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(themeManager.currentTheme.background.opacity(0.8))
                .blur(radius: 10)
        )
    }
}

struct CustomTabBar: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTab: Int
    
    let tabs = [
        ("house.fill", "Dashboard"),
        ("checkmark.square.fill", "Tasks"),
        ("paintpalette.fill", "Colors"),
        ("gearshape.fill", "Settings")
    ]
    
    var body: some View {
        HStack {
            ForEach(tabs.indices, id: \.self) { index in
                TabBarItem(
                    icon: tabs[index].0,
                    title: tabs[index].1,
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.currentTheme.accent1.opacity(0.8))
                .blur(radius: 10)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? ColorTheme.primaryButton : ColorTheme.primaryText.opacity(0.6))
                
                Text(title)
                    .font(.caption2)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? ColorTheme.primaryButton : ColorTheme.primaryText.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
    }
}

// MARK: - Tab Views

struct DashboardView: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Progress overview
                ProgressOverviewCard()
                    .environmentObject(taskManager)
                
                // Recent tasks
                RecentTasksCard()
                    .environmentObject(taskManager)
                
                // Quick actions
                QuickActionsCard()
            }
            .padding(20)
        }
    }
}

struct TasksView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Binding var showingAddTask: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if taskManager.tasks.isEmpty {
                EmptyTasksView(showingAddTask: $showingAddTask)
            } else {
                TaskListView()
                    .environmentObject(taskManager)
            }
        }
    }
}

struct ColorsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Color Palette")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.top, 20)
                
                ColorPalette()
            }
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.primaryText)
                .padding(.top, 20)
            
            VStack(spacing: 16) {
                CustomButton(
                    title: "Change Theme",
                    action: { themeManager.nextTheme() },
                    style: .primary
                )
                
                CustomButton(
                    title: "Reset Onboarding",
                    action: { hasSeenOnboarding = false },
                    style: .secondary
                )
                
                CustomButton(
                    title: "About ColorHarmony",
                    action: { },
                    style: .accent
                )
            }
            .padding(20)
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
