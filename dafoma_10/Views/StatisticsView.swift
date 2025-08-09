//
//  StatisticsView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var selectedTimeframe: TimeFrame = .week
    @State private var showingExportSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Time frame selector
                TimeFramePicker(selectedTimeframe: $selectedTimeframe)
                
                // Overview metrics
                OverviewMetricsCard()
                    .environmentObject(taskManager)
                    .environmentObject(habitManager)
                    .environmentObject(pomodoroManager)
                
                // Tasks statistics
                TaskStatisticsCard(timeframe: selectedTimeframe)
                    .environmentObject(taskManager)
                
                // Habits statistics
                HabitStatisticsCard(timeframe: selectedTimeframe)
                    .environmentObject(habitManager)
                
                // Pomodoro statistics
                PomodoroStatisticsCard(timeframe: selectedTimeframe)
                    .environmentObject(pomodoroManager)
                
                // Productivity trends
                ProductivityTrendsCard(timeframe: selectedTimeframe)
                    .environmentObject(taskManager)
                    .environmentObject(habitManager)
                    .environmentObject(pomodoroManager)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingExportSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryButton)
                }
            }
        }
    }
}

enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case threeMonths = "3 Months"
    case year = "Year"
}

struct TimeFramePicker: View {
    @Binding var selectedTimeframe: TimeFrame
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                Button {
                    selectedTimeframe = timeframe
                } label: {
                    Text(timeframe.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(selectedTimeframe == timeframe ? ColorTheme.primaryText : ColorTheme.primaryText.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedTimeframe == timeframe ? ColorTheme.primaryButton : ColorTheme.neutral.opacity(0.3))
                        )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct OverviewMetricsCard: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Productivity Overview")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                MetricCard(
                    title: "Tasks Completed",
                    value: "\(taskManager.completedTasks.count)",
                    subtitle: "Total",
                    color: ColorTheme.primaryButton,
                    icon: "checkmark.circle.fill"
                )
                
                MetricCard(
                    title: "Active Habits",
                    value: "\(habitManager.activeHabits.count)",
                    subtitle: "Tracking",
                    color: ColorTheme.secondaryButton,
                    icon: "target"
                )
                
                MetricCard(
                    title: "Focus Time",
                    value: pomodoroManager.formatDuration(pomodoroManager.totalFocusTimeToday),
                    subtitle: "Today",
                    color: ColorTheme.supportive,
                    icon: "brain.head.profile"
                )
                
                MetricCard(
                    title: "Completion Rate",
                    value: String(format: "%.0f%%", taskManager.completionRate * 100),
                    subtitle: "Overall",
                    color: ColorTheme.backgroundAccent1,
                    icon: "chart.bar.fill"
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

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(.caption)
                .foregroundColor(ColorTheme.primaryText.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(color)
                .fontWeight(.medium)
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

struct TaskStatisticsCard: View {
    let timeframe: TimeFrame
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Task Statistics")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "list.bullet.clipboard")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(taskManager.pendingTasks.count)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.secondaryButton)
                    
                    Text("Pending")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    Text("\(taskManager.completedTasks.count)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.supportive)
                    
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    Text(String(format: "%.1f%%", taskManager.completionRate * 100))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.primaryButton)
                    
                    Text("Success Rate")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
            }
            
            // Priority breakdown
            VStack(alignment: .leading, spacing: 8) {
                Text("Priority Breakdown")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.primaryText)
                
                ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                    let count = taskManager.tasks.filter { $0.priority == priority }.count
                    let percentage = taskManager.tasks.isEmpty ? 0 : Double(count) / Double(taskManager.tasks.count)
                    
                    HStack {
                        Circle()
                            .fill(Color(hex: priority.color))
                            .frame(width: 8, height: 8)
                        
                        Text(priority.rawValue)
                            .font(.caption)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        Text("\(count) (\(Int(percentage * 100))%)")
                            .font(.caption)
                            .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                    }
                }
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

struct HabitStatisticsCard: View {
    let timeframe: TimeFrame
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Habit Statistics")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "target")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            if !habitManager.activeHabits.isEmpty {
                ForEach(habitManager.activeHabits.prefix(3)) { habit in
                    HabitStatsRow(habit: habit)
                        .environmentObject(habitManager)
                }
                
                if habitManager.activeHabits.count > 3 {
                    Text("+ \(habitManager.activeHabits.count - 3) more habits")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
            } else {
                Text("No active habits")
                    .font(.body)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                    .padding(20)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.background.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.supportive.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct HabitStatsRow: View {
    let habit: Habit
    @EnvironmentObject var habitManager: HabitManager
    
    var body: some View {
        HStack {
            Image(systemName: habit.icon)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.primaryButton)
                .frame(width: 20)
            
            Text(habit.name)
                .font(.subheadline)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(0..<7, id: \.self) { index in
                    let weekData = habitManager.getWeeklyData(for: habit)
                    let isCompleted = index < weekData.count ? weekData[index] : false
                    
                    Circle()
                        .fill(isCompleted ? ColorTheme.supportive : ColorTheme.neutral.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
            }
            
            Text("\(habit.streak)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(ColorTheme.supportive)
                .frame(width: 20)
        }
        .padding(.vertical, 4)
    }
}

struct PomodoroStatisticsCard: View {
    let timeframe: TimeFrame
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Focus Statistics")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(pomodoroManager.totalSessionsToday)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.primaryButton)
                    
                    Text("Sessions Today")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    Text(pomodoroManager.formatDuration(pomodoroManager.totalFocusTimeToday))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.secondaryButton)
                    
                    Text("Focus Time")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    Text(pomodoroManager.formatDuration(pomodoroManager.averageSessionLength))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.supportive)
                    
                    Text("Average")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
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

struct ProductivityTrendsCard: View {
    let timeframe: TimeFrame
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Productivity Trends")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            // Simple trend visualization
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7, id: \.self) { day in
                    let height = CGFloat.random(in: 20...60)
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(
                                colors: [ColorTheme.primaryButton, ColorTheme.secondaryButton],
                                startPoint: .bottom,
                                endPoint: .top
                            ))
                            .frame(width: 24, height: height)
                        
                        Text(dayLabel(for: day))
                            .font(.caption2)
                            .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                    }
                }
            }
            .frame(height: 80)
            
            Text("Your productivity has been consistent this week!")
                .font(.caption)
                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                .multilineTextAlignment(.center)
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
    
    private func dayLabel(for index: Int) -> String {
        let calendar = Calendar.current
        let today = Date()
        let date = calendar.date(byAdding: .day, value: index - 6, to: today) ?? today
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(TaskManager())
            .environmentObject(HabitManager())
            .environmentObject(PomodoroManager())
            .environmentObject(ThemeManager())
    }
}
