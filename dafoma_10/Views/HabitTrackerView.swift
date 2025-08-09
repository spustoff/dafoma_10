//
//  HabitTrackerView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import SwiftUI

struct HabitTrackerView: View {
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingAddHabit = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with stats
                HabitStatsCard()
                    .environmentObject(habitManager)
                
                // Today's habits
                TodayHabitsCard()
                    .environmentObject(habitManager)
                
                // All habits list
                if !habitManager.activeHabits.isEmpty {
                    HabitsListCard()
                        .environmentObject(habitManager)
                } else {
                    EmptyHabitsView()
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView()
                .environmentObject(habitManager)
                .environmentObject(themeManager)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddHabit = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryButton)
                }
            }
        }
    }
}

struct HabitStatsCard: View {
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
                
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            HStack(spacing: 20) {
                StatItem(
                    title: "Today",
                    value: "\(habitManager.habitsCompletedToday())/\(habitManager.activeHabits.count)",
                    color: ColorTheme.primaryButton
                )
                
                StatItem(
                    title: "Total",
                    value: "\(habitManager.totalHabitsCompleted)",
                    color: ColorTheme.secondaryButton
                )
                
                StatItem(
                    title: "Average",
                    value: String(format: "%.0f%%", habitManager.averageCompletionRate * 100),
                    color: ColorTheme.supportive
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

struct TodayHabitsCard: View {
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
                
                Image(systemName: "calendar")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(habitManager.activeHabits) { habit in
                    TodayHabitCard(habit: habit)
                        .environmentObject(habitManager)
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

struct TodayHabitCard: View {
    let habit: Habit
    @EnvironmentObject var habitManager: HabitManager
    
    var isCompletedToday: Bool {
        habit.isCompletedForDate(Date())
    }
    
    var body: some View {
        Button {
            habitManager.toggleHabitCompletion(habit)
        } label: {
            VStack(spacing: 8) {
                Image(systemName: habit.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isCompletedToday ? ColorTheme.primaryText : ColorTheme.primaryButton)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isCompletedToday ? ColorTheme.supportive : ColorTheme.neutral.opacity(0.3))
                    )
                
                Text(habit.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                HStack {
                    ForEach(0..<7, id: \.self) { index in
                        let weekData = habitManager.getWeeklyData(for: habit)
                        let isCompleted = index < weekData.count ? weekData[index] : false
                        
                        Circle()
                            .fill(isCompleted ? ColorTheme.supportive : ColorTheme.neutral.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.neutral.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isCompletedToday ? ColorTheme.supportive : Color.clear, lineWidth: 2)
                    )
            )
        }
        .scaleEffect(isCompletedToday ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCompletedToday)
    }
}

struct HabitsListCard: View {
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("All Habits")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "list.bullet")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            ForEach(habitManager.activeHabits) { habit in
                HabitRowView(habit: habit)
                    .environmentObject(habitManager)
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

struct HabitRowView: View {
    let habit: Habit
    @EnvironmentObject var habitManager: HabitManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: habit.icon)
                .font(.system(size: 20))
                .foregroundColor(ColorTheme.primaryButton)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Streak: \(habit.streak) days")
                    .font(.caption)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
            }
            
            Spacer()
            
            // Weekly visualization
            HStack(spacing: 4) {
                ForEach(0..<7, id: \.self) { index in
                    let weekData = habitManager.getWeeklyData(for: habit)
                    let isCompleted = index < weekData.count ? weekData[index] : false
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(isCompleted ? ColorTheme.supportive : ColorTheme.neutral.opacity(0.3))
                        .frame(width: 12, height: 24)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorTheme.neutral.opacity(0.1))
        )
    }
}

struct EmptyHabitsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "target")
                .font(.system(size: 48))
                .foregroundColor(ColorTheme.primaryButton.opacity(0.7))
            
            Text("No Habits Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Start building healthy habits by adding your first habit tracker.")
                .font(.body)
                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.neutral.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.primaryButton.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct HabitTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerView()
            .environmentObject(HabitManager())
            .environmentObject(ThemeManager())
    }
}
