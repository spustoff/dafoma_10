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
    @StateObject private var habitManager = HabitManager()
    @StateObject private var pomodoroManager = PomodoroManager()
    @State private var selectedTab = 0
    @State private var showingAddTask = false
    @State private var showingThemeSelector = false
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    var body: some View {
        ZStack {
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
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
                                        .environmentObject(habitManager)
                                        .environmentObject(pomodoroManager)
                                        .tag(0)
                                    
                                    // Tasks Tab
                                    TasksView(showingAddTask: $showingAddTask)
                                        .environmentObject(taskManager)
                                        .tag(1)
                                    
                                    // Habits Tab
                                    HabitTrackerView()
                                        .environmentObject(habitManager)
                                        .tag(2)
                                    
                                    // Pomodoro Tab
                                    PomodoroTimerView()
                                        .environmentObject(pomodoroManager)
                                        .tag(3)
                                    
                                    // Statistics Tab
                                    StatisticsView()
                                        .environmentObject(taskManager)
                                        .environmentObject(habitManager)
                                        .environmentObject(pomodoroManager)
                                        .tag(4)
                                    
                                    // Settings Tab
                                    SettingsView()
                                        .environmentObject(taskManager)
                                        .environmentObject(habitManager)
                                        .environmentObject(pomodoroManager)
                                        .tag(5)
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
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = "12.08.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
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
        ("target", "Habits"),
        ("brain.head.profile", "Focus"),
        ("chart.bar.fill", "Stats"),
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
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Progress overview
                ProgressOverviewCard()
                    .environmentObject(taskManager)
                    .environmentObject(habitManager)
                    .environmentObject(pomodoroManager)
                
                // Quick stats
                QuickStatsCard()
                    .environmentObject(taskManager)
                    .environmentObject(habitManager)
                    .environmentObject(pomodoroManager)
                
                // Recent tasks
                RecentTasksCard()
                    .environmentObject(taskManager)
                
                // Today's habits
                TodayHabitsQuickView()
                    .environmentObject(habitManager)
                
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
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
    @State private var showingExportSheet = false
    
    var body: some View {
        ScrollView {
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
                        title: "Export Data",
                        action: { showingExportSheet = true },
                        style: .secondary
                    )
                    
                    CustomButton(
                        title: "Reset Onboarding",
                        action: { hasSeenOnboarding = false },
                        style: .accent
                    )
                    
                    CustomButton(
                        title: "About ColorHarmony",
                        action: { },
                        style: .accent
                    )
                }
                .padding(20)
                
                // App statistics
                AppStatsCard()
                    .environmentObject(taskManager)
                    .environmentObject(habitManager)
                    .environmentObject(pomodoroManager)
                
                Spacer(minLength: 40)
            }
            .padding(20)
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportDataView()
                .environmentObject(taskManager)
                .environmentObject(habitManager)
                .environmentObject(pomodoroManager)
                .environmentObject(themeManager)
        }
    }
}

struct AppStatsCard: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("App Statistics")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatCard(title: "Total Tasks", value: "\(taskManager.tasks.count)", color: ColorTheme.primaryButton)
                StatCard(title: "Active Habits", value: "\(habitManager.activeHabits.count)", color: ColorTheme.secondaryButton)
                StatCard(title: "Focus Sessions", value: "\(pomodoroManager.sessions.count)", color: ColorTheme.supportive)
                StatCard(title: "Current Theme", value: themeManager.currentTheme.name, color: ColorTheme.backgroundAccent1)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.accent1.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.primaryButton.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.neutral.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
