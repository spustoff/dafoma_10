//
//  ExportDataView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import SwiftUI

struct ExportDataView: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedExportType: ExportType = .all
    @State private var selectedFormat: ExportFormat = .json
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    
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
                        
                        Text("Export Data")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        CustomButton(
                            title: "Export",
                            action: exportData,
                            style: .primary,
                            size: .small
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
                            // Export type selection
                            ExportTypeCard(selectedType: $selectedExportType)
                            
                            // Format selection
                            FormatSelectionCard(selectedFormat: $selectedFormat)
                            
                            // Data preview
                            DataPreviewCard()
                                .environmentObject(taskManager)
                                .environmentObject(habitManager)
                                .environmentObject(pomodoroManager)
                            
                            Spacer(minLength: 40)
                        }
                        .padding(24)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = exportURL {
                ShareSheet(activityItems: [url])
            }
        }
    }
    
    private func exportData() {
        do {
            let data = try generateExportData()
            let url = try saveToTemporaryFile(data: data)
            exportURL = url
            showingShareSheet = true
        } catch {
            print("Export failed: \(error)")
        }
    }
    
    private func generateExportData() throws -> Data {
        var exportData: [String: Any] = [:]
        
        switch selectedExportType {
        case .all:
            exportData["tasks"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(taskManager.tasks))
            exportData["habits"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(habitManager.habits))
            exportData["sessions"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(pomodoroManager.sessions))
        case .tasks:
            exportData["tasks"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(taskManager.tasks))
        case .habits:
            exportData["habits"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(habitManager.habits))
        case .pomodoro:
            exportData["sessions"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(pomodoroManager.sessions))
        }
        
        exportData["exportDate"] = ISO8601DateFormatter().string(from: Date())
        exportData["appVersion"] = "1.0"
        
        switch selectedFormat {
        case .json:
            return try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
        case .csv:
            return try generateCSVData()
        }
    }
    
    private func generateCSVData() throws -> Data {
        var csvContent = ""
        
        switch selectedExportType {
        case .all, .tasks:
            csvContent += "Tasks\n"
            csvContent += "Title,Description,Priority,Completed,Created Date,Due Date\n"
            for task in taskManager.tasks {
                csvContent += "\"\(task.title)\",\"\(task.description)\",\(task.priority.rawValue),\(task.isCompleted),\(task.createdDate),\(task.dueDate?.description ?? "")\n"
            }
            csvContent += "\n"
        case .habits:
            break
        case .pomodoro:
            break
        }
        
        if selectedExportType == .all || selectedExportType == .habits {
            csvContent += "Habits\n"
            csvContent += "Name,Description,Target Days,Streak,Completion Rate\n"
            for habit in habitManager.habits {
                csvContent += "\"\(habit.name)\",\"\(habit.description)\",\(habit.targetDaysPerWeek),\(habit.streak),\(habit.completionRate)\n"
            }
        }
        
        return csvContent.data(using: .utf8) ?? Data()
    }
    
    private func saveToTemporaryFile(data: Data) throws -> URL {
        let fileName = "ColorHarmony_Export_\(Date().timeIntervalSince1970)"
        let fileExtension = selectedFormat.fileExtension
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(fileName).\(fileExtension)")
        
        try data.write(to: url)
        return url
    }
}

enum ExportType: String, CaseIterable {
    case all = "All Data"
    case tasks = "Tasks Only"
    case habits = "Habits Only"
    case pomodoro = "Pomodoro Sessions"
    
    var icon: String {
        switch self {
        case .all: return "doc.fill"
        case .tasks: return "checkmark.circle.fill"
        case .habits: return "target"
        case .pomodoro: return "brain.head.profile"
        }
    }
}

enum ExportFormat: String, CaseIterable {
    case json = "JSON"
    case csv = "CSV"
    
    var fileExtension: String {
        switch self {
        case .json: return "json"
        case .csv: return "csv"
        }
    }
    
    var description: String {
        switch self {
        case .json: return "Structured data format, best for importing back"
        case .csv: return "Spreadsheet compatible format"
        }
    }
}

struct ExportTypeCard: View {
    @Binding var selectedType: ExportType
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("What to Export")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(ExportType.allCases, id: \.self) { type in
                    ExportTypeButton(type: type, isSelected: selectedType == type) {
                        selectedType = type
                    }
                }
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

struct ExportTypeButton: View {
    let type: ExportType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.primaryButton)
                
                Text(type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.primaryButton : ColorTheme.neutral.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.primaryButton.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct FormatSelectionCard: View {
    @Binding var selectedFormat: ExportFormat
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Export Format")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "doc.text")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            ForEach(ExportFormat.allCases, id: \.self) { format in
                FormatOptionRow(format: format, isSelected: selectedFormat == format) {
                    selectedFormat = format
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

struct FormatOptionRow: View {
    let format: ExportFormat
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(format.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(format.description)
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? ColorTheme.supportive : ColorTheme.neutral.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.supportive.opacity(0.1) : ColorTheme.neutral.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorTheme.supportive : Color.clear, lineWidth: 1)
                    )
            )
        }
    }
}

struct DataPreviewCard: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Data Summary")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "list.bullet.clipboard")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            VStack(spacing: 12) {
                DataSummaryRow(title: "Tasks", count: taskManager.tasks.count, icon: "checkmark.circle")
                DataSummaryRow(title: "Habits", count: habitManager.habits.count, icon: "target")
                DataSummaryRow(title: "Pomodoro Sessions", count: pomodoroManager.sessions.count, icon: "brain.head.profile")
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

struct DataSummaryRow: View {
    let title: String
    let count: Int
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.primaryButton)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text("\(count) items")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ExportDataView_Previews: PreviewProvider {
    static var previews: some View {
        ExportDataView()
            .environmentObject(TaskManager())
            .environmentObject(HabitManager())
            .environmentObject(PomodoroManager())
            .environmentObject(ThemeManager())
    }
}
