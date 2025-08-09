//
//  DashboardComponents.swift
//  ColorHarmony: Blink
//
//  Updated by Вячеслав on 7/31/25.
//

import SwiftUI

struct ProgressOverviewCard: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Progress")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            // Circular progress indicators
            HStack(spacing: 20) {
                CircularProgressView(
                    progress: taskManager.completionRate,
                    color: ColorTheme.primaryButton,
                    title: "Tasks",
                    subtitle: "\(taskManager.completedTasks.count)/\(taskManager.tasks.count)"
                )
                
                CircularProgressView(
                    progress: habitManager.averageCompletionRate,
                    color: ColorTheme.secondaryButton,
                    title: "Habits",
                    subtitle: "\(habitManager.habitsCompletedToday())/\(habitManager.activeHabits.count)"
                )
                
                CircularProgressView(
                    progress: min(1.0, pomodoroManager.totalFocusTimeToday / (4 * 25 * 60)), // 4 sessions target
                    color: ColorTheme.supportive,
                    title: "Focus",
                    subtitle: pomodoroManager.formatDuration(pomodoroManager.totalFocusTimeToday)
                )
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

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(ColorTheme.neutral.opacity(0.3), lineWidth: 6)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: progress)
                
                Text(String(format: "%.0f%%", progress * 100))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(ColorTheme.primaryText)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuickStatsCard: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Stats")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "speedometer")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickStatItem(
                    value: "\(taskManager.tasks.filter { $0.priority == .high && !$0.isCompleted }.count)",
                    title: "High Priority",
                    color: Color(hex: "#f0048d"),
                    icon: "exclamationmark.triangle.fill"
                )
                
                QuickStatItem(
                    value: "\(habitManager.habits.map { $0.streak }.max() ?? 0)",
                    title: "Best Streak",
                    color: ColorTheme.supportive,
                    icon: "flame.fill"
                )
                
                QuickStatItem(
                    value: "\(pomodoroManager.totalSessionsToday)",
                    title: "Focus Sessions",
                    color: ColorTheme.primaryButton,
                    icon: "brain.head.profile"
                )
                
                QuickStatItem(
                    value: "\(Calendar.current.component(.weekday, from: Date()))",
                    title: "Day of Week",
                    color: ColorTheme.backgroundAccent1,
                    icon: "calendar"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.accent2.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.secondaryButton.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct QuickStatItem: View {
    let value: String
    let title: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.primaryText)
            
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

struct RecentTasksCard: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var recentTasks: [TaskItem] {
        Array(taskManager.tasks.filter { !$0.isCompleted }.prefix(3))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Tasks")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "list.bullet")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            if recentTasks.isEmpty {
                Text("No pending tasks")
                    .font(.body)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                    .padding(20)
            } else {
                ForEach(recentTasks) { task in
                    TaskQuickRow(task: task)
                        .environmentObject(taskManager)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.background.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.primaryText.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct TaskQuickRow: View {
    let task: TaskItem
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                taskManager.toggleTaskCompletion(task)
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? ColorTheme.supportive : Color(hex: task.priority.color))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.primaryText)
                    .strikethrough(task.isCompleted)
                
                Text(task.priority.rawValue)
                    .font(.caption2)
                    .foregroundColor(Color(hex: task.priority.color))
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            if let dueDate = task.dueDate {
                Text(formatDueDate(dueDate))
                    .font(.caption2)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorTheme.neutral.opacity(0.1))
        )
    }
    
    private func formatDueDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct TodayHabitsQuickView: View {
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Habits")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "target")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            if habitManager.activeHabits.isEmpty {
                Text("No active habits")
                    .font(.body)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                    .padding(20)
            } else {
                HStack(spacing: 12) {
                    ForEach(habitManager.activeHabits.prefix(4)) { habit in
                        HabitQuickItem(habit: habit)
                            .environmentObject(habitManager)
                    }
                }
                
                if habitManager.activeHabits.count > 4 {
                    Text("+ \(habitManager.activeHabits.count - 4) more")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.accent1.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.supportive.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct HabitQuickItem: View {
    let habit: Habit
    @EnvironmentObject var habitManager: HabitManager
    
    var isCompletedToday: Bool {
        habit.isCompletedForDate(Date())
    }
    
    var body: some View {
        Button {
            habitManager.toggleHabitCompletion(habit)
        } label: {
            VStack(spacing: 6) {
                Image(systemName: habit.icon)
                    .font(.title3)
                    .foregroundColor(isCompletedToday ? ColorTheme.primaryText : ColorTheme.primaryButton)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(isCompletedToday ? ColorTheme.supportive : ColorTheme.neutral.opacity(0.3))
                    )
                
                Text(habit.name)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(isCompletedToday ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCompletedToday)
    }
}

struct QuickActionsCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Actions")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "bolt.fill")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickActionButton(
                    title: "Add Task",
                    icon: "plus.circle.fill",
                    color: ColorTheme.primaryButton
                ) {
                    // Action handled by parent view
                }
                
                QuickActionButton(
                    title: "Start Focus",
                    icon: "brain.head.profile",
                    color: ColorTheme.secondaryButton
                ) {
                    // Navigate to Pomodoro timer
                }
                
                QuickActionButton(
                    title: "View Stats",
                    icon: "chart.bar.fill",
                    color: ColorTheme.supportive
                ) {
                    // Navigate to statistics
                }
                
                QuickActionButton(
                    title: "Change Theme",
                    icon: "paintpalette.fill",
                    color: ColorTheme.backgroundAccent1
                ) {
                    themeManager.nextTheme()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.background.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.primaryText.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
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
            .frame(height: 60)
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
}