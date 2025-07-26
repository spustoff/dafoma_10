//
//  AddTaskView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: TaskItem.Priority = .medium
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    @State private var selectedColorTheme = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        themeManager.currentTheme.background,
                        themeManager.currentTheme.accent1.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(ColorTheme.primaryText)
                        .font(.body)
                        
                        Spacer()
                        
                        Text("New Task")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        CustomButton(
                            title: "Save",
                            action: saveTask,
                            style: .primary,
                            size: .small,
                            isEnabled: !title.isEmpty
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(themeManager.currentTheme.background.opacity(0.9))
                            .blur(radius: 10)
                    )
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 24) {
                        // Title input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Title")
                                .font(.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter task title", text: $title)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Description input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter task description", text: $description)
                                .textFieldStyle(CustomTextFieldStyle())                        }
                        
                        // Priority selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Priority")
                                .font(.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(TaskItem.Priority.allCases, id: \.self) { priorityOption in
                                    PriorityButton(
                                        priority: priorityOption,
                                        isSelected: priority == priorityOption
                                    ) {
                                        priority = priorityOption
                                    }
                                }
                            }
                        }
                        
                        // Due date toggle and picker
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Set Due Date", isOn: $hasDueDate)
                                .toggleStyle(CustomToggleStyle())
                                .foregroundColor(ColorTheme.primaryText)
                            
                            if hasDueDate {
                                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .tint(ColorTheme.primaryButton)
                            }
                        }
                        
                        // Color theme selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Color Theme")
                                .font(.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(0..<themeManager.themes.count, id: \.self) { index in
                                    ColorThemeButton(
                                        theme: themeManager.themes[index],
                                        isSelected: selectedColorTheme == index
                                    ) {
                                        selectedColorTheme = index
                                    }
                                }
                            }
                        }
                        
                            Spacer(minLength: 40)
                        }
                        .padding(24)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func saveTask() {
        let newTask = TaskItem(
            title: title,
            description: description,
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority,
            colorTheme: selectedColorTheme
        )
        
        taskManager.addTask(newTask)
        dismiss()
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.neutral.opacity(0.9))
            )
            .foregroundColor(ColorTheme.secondaryText)
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 50, height: 30)
                .foregroundColor(configuration.isOn ? ColorTheme.primaryButton : ColorTheme.neutral.opacity(0.5))
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 26, height: 26)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.spring(response: 0.3), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct PriorityButton: View {
    let priority: TaskItem.Priority
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(priority.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(hex: priority.color) : ColorTheme.neutral.opacity(0.3))
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct ColorThemeButton: View {
    let theme: ThemeSet
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(theme.primary)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(
                            isSelected ? ColorTheme.supportive : Color.clear,
                            lineWidth: 3
                        )
                )
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
            .environmentObject(TaskManager())
            .environmentObject(ThemeManager())
    }
} 
