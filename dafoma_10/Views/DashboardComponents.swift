//
//  DashboardComponents.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Progress Overview Card
struct ProgressOverviewCard: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's Progress")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("\(taskManager.completedTasks.count) of \(taskManager.tasks.count) tasks completed")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: taskManager.completionRate,
                    size: 60
                )
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Completion Rate")
                        .font(.subheadline)
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Text("\(Int(taskManager.completionRate * 100))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.currentTheme.primary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorTheme.neutral.opacity(0.3))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [themeManager.currentTheme.primary, themeManager.currentTheme.secondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * taskManager.completionRate, height: 8)
                            .animation(.easeInOut(duration: 1), value: taskManager.completionRate)
                    }
                }
                .frame(height: 8)
            }
            
            // Quick stats
            HStack(spacing: 16) {
                StatItem(
                    title: "Pending",
                    value: "\(taskManager.pendingTasks.count)",
                    color: themeManager.currentTheme.accent1
                )
                
                StatItem(
                    title: "Completed",
                    value: "\(taskManager.completedTasks.count)",
                    color: themeManager.currentTheme.primary
                )
                
                StatItem(
                    title: "High Priority",
                    value: "\(taskManager.tasks.filter { $0.priority == .high }.count)",
                    color: themeManager.currentTheme.secondary
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.neutral.opacity(0.1))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct CircularProgressView: View {
    let progress: Double
    let size: CGFloat
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(ColorTheme.neutral.opacity(0.3), lineWidth: 6)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [themeManager.currentTheme.primary, themeManager.currentTheme.secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 6
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.primaryText)
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Recent Tasks Card
struct RecentTasksCard: View {
    @EnvironmentObject var taskManager: TaskManager
    
    var recentTasks: [TaskItem] {
        Array(taskManager.tasks.prefix(3))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Tasks")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if !taskManager.tasks.isEmpty {
                    Button("View All") {
                        // Navigate to tasks tab
                    }
                    .font(.caption)
                    .foregroundColor(ColorTheme.primaryButton)
                }
            }
            
            if taskManager.tasks.isEmpty {
                EmptyStateView(
                    icon: "checkmark.square",
                    title: "No Tasks Yet",
                    description: "Create your first task to get started"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(recentTasks) { task in
                        TaskRowView(task: task)
                            .environmentObject(taskManager)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.neutral.opacity(0.1))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Quick Actions Card
struct QuickActionsCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "Add Task",
                    color: themeManager.currentTheme.primary
                ) {
                    // Add task action
                }
                
                QuickActionButton(
                    icon: "paintpalette.fill",
                    title: "Change Theme",
                    color: themeManager.currentTheme.secondary
                ) {
                    themeManager.nextTheme()
                }
                
                QuickActionButton(
                    icon: "calendar",
                    title: "Schedule",
                    color: themeManager.currentTheme.accent1
                ) {
                    // Schedule action
                }
                
                QuickActionButton(
                    icon: "chart.bar.fill",
                    title: "Analytics",
                    color: themeManager.currentTheme.accent2
                ) {
                    // Analytics action
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.neutral.opacity(0.1))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(ColorTheme.primaryText.opacity(0.5))
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
} 