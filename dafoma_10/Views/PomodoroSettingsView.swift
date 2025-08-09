//
//  PomodoroSettingsView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import SwiftUI

struct PomodoroSettingsView: View {
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var workDuration: Double = 25
    @State private var shortBreakDuration: Double = 5
    @State private var longBreakDuration: Double = 15
    @State private var sessionsUntilLongBreak: Double = 4
    
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
                        
                        Text("Pomodoro Settings")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        CustomButton(
                            title: "Save",
                            action: saveSettings,
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
                            // Work Duration
                            SettingSlider(
                                title: "Work Duration",
                                value: $workDuration,
                                range: 15...60,
                                unit: "minutes",
                                icon: "brain.head.profile",
                                color: ColorTheme.primaryButton
                            )
                            
                            // Short Break Duration
                            SettingSlider(
                                title: "Short Break",
                                value: $shortBreakDuration,
                                range: 3...15,
                                unit: "minutes",
                                icon: "cup.and.saucer.fill",
                                color: ColorTheme.secondaryButton
                            )
                            
                            // Long Break Duration
                            SettingSlider(
                                title: "Long Break",
                                value: $longBreakDuration,
                                range: 15...30,
                                unit: "minutes",
                                icon: "bed.double.fill",
                                color: ColorTheme.supportive
                            )
                            
                            // Sessions Until Long Break
                            SettingSlider(
                                title: "Sessions Until Long Break",
                                value: $sessionsUntilLongBreak,
                                range: 2...8,
                                unit: "sessions",
                                icon: "target",
                                color: ColorTheme.backgroundAccent1
                            )
                            
                            // Preset Configurations
                            PresetConfigurationsCard()
                            
                            Spacer(minLength: 40)
                        }
                        .padding(24)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadCurrentSettings()
        }
    }
    
    private func loadCurrentSettings() {
        workDuration = pomodoroManager.currentSession.workDuration / 60
        shortBreakDuration = pomodoroManager.currentSession.shortBreakDuration / 60
        longBreakDuration = pomodoroManager.currentSession.longBreakDuration / 60
        sessionsUntilLongBreak = Double(pomodoroManager.currentSession.sessionsUntilLongBreak)
    }
    
    private func saveSettings() {
        pomodoroManager.customizeSession(
            work: workDuration * 60,
            shortBreak: shortBreakDuration * 60,
            longBreak: longBreakDuration * 60,
            sessionsUntilLongBreak: Int(sessionsUntilLongBreak)
        )
        dismiss()
    }
}

struct SettingSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Text("\(Int(value)) \(unit)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color.opacity(0.2))
                    )
            }
            
            Slider(value: $value, in: range, step: 1)
                .accentColor(color)
        }
        .padding(20)
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

struct PresetConfigurationsCard: View {
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    let presets: [(name: String, work: Double, short: Double, long: Double, sessions: Int)] = [
        ("Classic", 25, 5, 15, 4),
        ("Short Focus", 15, 3, 10, 6),
        ("Extended", 45, 10, 30, 3),
        ("Ultra Focus", 90, 20, 45, 2)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Preset Configurations")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(presets, id: \.name) { preset in
                    PresetCard(preset: preset) {
                        pomodoroManager.customizeSession(
                            work: preset.work * 60,
                            shortBreak: preset.short * 60,
                            longBreak: preset.long * 60,
                            sessionsUntilLongBreak: preset.sessions
                        )
                        dismiss()
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
                        .stroke(ColorTheme.primaryButton.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct PresetCard: View {
    let preset: (name: String, work: Double, short: Double, long: Double, sessions: Int)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(preset.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.primaryText)
                
                VStack(spacing: 4) {
                    Text("\(Int(preset.work))m work")
                        .font(.caption2)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.8))
                    
                    Text("\(Int(preset.short))m break")
                        .font(.caption2)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.8))
                    
                    Text("\(preset.sessions) cycles")
                        .font(.caption2)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.8))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.neutral.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.primaryButton.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct PomodoroSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroSettingsView()
            .environmentObject(PomodoroManager())
            .environmentObject(ThemeManager())
    }
}
