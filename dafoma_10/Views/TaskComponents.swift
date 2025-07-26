//
//  TaskComponents.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - Empty Tasks View
struct EmptyTasksView: View {
    @Binding var showingAddTask: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 24) {
                // Animated icon
                Image(systemName: "checkmark.square.fill")
                    .font(.system(size: 80))
                    .foregroundColor(themeManager.currentTheme.primary)
                    .symbolRenderingMode(.hierarchical)
                
                VStack(spacing: 12) {
                    Text("Ready to Get Organized?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Create your first task to start boosting your productivity with beautiful color themes.")
                        .font(.body)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                CustomButton(
                    title: "Create Your First Task",
                    action: { showingAddTask = true },
                    style: .primary,
                    size: .large
                )
                .padding(.top, 8)
            }
            
            Spacer()
            
            // Feature highlights
            VStack(spacing: 16) {
                Text("What you can do:")
                    .font(.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                VStack(spacing: 12) {
                    FeatureHighlight(
                        icon: "paintbrush.fill",
                        text: "Organize with beautiful color themes"
                    )
                    FeatureHighlight(
                        icon: "flag.fill",
                        text: "Set priorities for better focus"
                    )
                    FeatureHighlight(
                        icon: "calendar.badge.clock",
                        text: "Schedule with due dates"
                    )
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding(20)
    }
}

struct FeatureHighlight: View {
    let icon: String
    let text: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(themeManager.currentTheme.primary)
                .frame(width: 24)
            
            Text(text)
                .font(.body)
                .foregroundColor(ColorTheme.primaryText.opacity(0.8))
            
            Spacer()
        }
    }
}

// MARK: - Task List View
struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var selectedFilter: TaskFilter = .all
    
    enum TaskFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case completed = "Completed"
        case high = "High Priority"
    }
    
    var filteredTasks: [TaskItem] {
        switch selectedFilter {
        case .all:
            return taskManager.tasks
        case .pending:
            return taskManager.pendingTasks
        case .completed:
            return taskManager.completedTasks
        case .high:
            return taskManager.tasks.filter { $0.priority == .high }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter tabs
            TaskFilterTabs(selectedFilter: $selectedFilter)
            
            // Task list
            if filteredTasks.isEmpty {
                EmptyFilteredTasksView(filter: selectedFilter)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTasks) { task in
                            TaskRowView(task: task)
                                .environmentObject(taskManager)
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
}

struct TaskFilterTabs: View {
    @Binding var selectedFilter: TaskListView.TaskFilter
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(TaskListView.TaskFilter.allCases, id: \.self) { filter in
                    FilterTab(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(themeManager.currentTheme.background.opacity(0.8))
        )
    }
}

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.primaryText.opacity(0.6))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? themeManager.currentTheme.primary : Color.clear)
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct EmptyFilteredTasksView: View {
    let filter: TaskListView.TaskFilter
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: emptyIcon)
                .font(.system(size: 60))
                .foregroundColor(themeManager.currentTheme.primary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(emptyTitle)
                    .font(.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(emptyDescription)
                    .font(.body)
                    .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(40)
    }
    
    private var emptyIcon: String {
        switch filter {
        case .all: return "tray"
        case .pending: return "clock"
        case .completed: return "checkmark.circle"
        case .high: return "exclamationmark.triangle"
        }
    }
    
    private var emptyTitle: String {
        switch filter {
        case .all: return "No Tasks"
        case .pending: return "No Pending Tasks"
        case .completed: return "No Completed Tasks"
        case .high: return "No High Priority Tasks"
        }
    }
    
    private var emptyDescription: String {
        switch filter {
        case .all: return "You're all caught up!"
        case .pending: return "Great! All tasks are completed."
        case .completed: return "Complete some tasks to see them here."
        case .high: return "No urgent tasks at the moment."
        }
    }
}

// MARK: - Task Row View
struct TaskRowView: View {
    let task: TaskItem
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Completion toggle
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        taskManager.toggleTaskCompletion(task)
                    }
                } label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(task.isCompleted ? ColorTheme.supportive : themeManager.currentTheme.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    // Title
                    Text(task.title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(task.isCompleted ? ColorTheme.primaryText.opacity(0.6) : ColorTheme.primaryText)
                        .strikethrough(task.isCompleted)
                    
                    // Metadata row
                    HStack(spacing: 8) {
                        // Priority badge
                        Text(task.priority.rawValue)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: task.priority.color))
                            )
                        
                        // Due date if exists
                        if let dueDate = task.dueDate {
                            Text(formatDate(dueDate))
                                .font(.caption2)
                                .foregroundColor(ColorTheme.primaryText.opacity(0.6))
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                // Expand/collapse button
                if !task.description.isEmpty {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(ColorTheme.primaryText.opacity(0.6))
                    }
                }
                
                // Theme color indicator
                Circle()
                    .fill(themeManager.themes[task.colorTheme].primary)
                    .frame(width: 12, height: 12)
            }
            .padding(16)
            
            // Expanded description
            if isExpanded && !task.description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(ColorTheme.primaryText.opacity(0.2))
                    
                    Text(task.description)
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.neutral.opacity(0.1))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .opacity(task.isCompleted ? 0.7 : 1.0)
        .scaleEffect(task.isCompleted ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: Date()) {
            formatter.dateFormat = "HH:mm"
            return "Today \(formatter.string(from: date))"
        } else if calendar.isDate(date, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()) {
            formatter.dateFormat = "HH:mm"
            return "Tomorrow \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }
} 