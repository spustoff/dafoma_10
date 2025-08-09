//
//  PomodoroTimerView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import SwiftUI

struct PomodoroTimerView: View {
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Session Type Header
                SessionTypeHeader()
                    .environmentObject(pomodoroManager)
                
                // Main Timer Display
                TimerDisplayCard()
                    .environmentObject(pomodoroManager)
                
                // Control Buttons
                TimerControlsCard()
                    .environmentObject(pomodoroManager)
                
                // Today's Stats
                TodayStatsCard()
                    .environmentObject(pomodoroManager)
            }
            .padding(20)
        }
        .sheet(isPresented: $showingSettings) {
            PomodoroSettingsView()
                .environmentObject(pomodoroManager)
                .environmentObject(themeManager)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryButton)
                }
            }
        }
    }
}

struct SessionTypeHeader: View {
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: pomodoroManager.currentSession.currentSessionType.icon)
                .font(.system(size: 32))
                .foregroundColor(Color(hex: pomodoroManager.currentSession.currentSessionType.color))
            
            Text(pomodoroManager.currentSession.currentSessionType.rawValue)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Session \(pomodoroManager.currentSession.completedSessions + 1)")
                .font(.subheadline)
                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.accent1.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: pomodoroManager.currentSession.currentSessionType.color).opacity(0.5), lineWidth: 2)
                )
        )
    }
}

struct TimerDisplayCard: View {
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    private var progress: Double {
        let total = pomodoroManager.currentSession.currentSessionDuration
        let remaining = pomodoroManager.timeRemaining
        return (total - remaining) / total
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(ColorTheme.neutral.opacity(0.3), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color(hex: pomodoroManager.currentSession.currentSessionType.color),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: progress)
                
                // Time display
                VStack {
                    Text(pomodoroManager.formatTime(pomodoroManager.timeRemaining))
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("remaining")
                        .font(.caption)
                        .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                }
            }
            
            // Progress indicators
            HStack(spacing: 8) {
                ForEach(0..<pomodoroManager.currentSession.sessionsUntilLongBreak, id: \.self) { index in
                    Circle()
                        .fill(index < pomodoroManager.currentSession.completedSessions / 2 + 1 ? 
                              Color(hex: pomodoroManager.currentSession.currentSessionType.color) : 
                              ColorTheme.neutral.opacity(0.3))
                        .frame(width: 12, height: 12)
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

struct TimerControlsCard: View {
    @EnvironmentObject var pomodoroManager: PomodoroManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                // Start/Pause Button
                Button {
                    if pomodoroManager.timerState == .running {
                        pomodoroManager.pauseTimer()
                    } else {
                        pomodoroManager.startTimer()
                    }
                } label: {
                    HStack {
                        Image(systemName: pomodoroManager.timerState == .running ? "pause.fill" : "play.fill")
                            .font(.title2)
                        
                        Text(pomodoroManager.timerState == .running ? "Pause" : "Start")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.primaryButton)
                    )
                }
                
                // Stop Button
                Button {
                    pomodoroManager.stopTimer()
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorTheme.secondaryButton)
                        )
                }
                .disabled(pomodoroManager.timerState == .idle)
                .opacity(pomodoroManager.timerState == .idle ? 0.5 : 1.0)
                
                // Reset Button
                Button {
                    pomodoroManager.resetTimer()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorTheme.neutral.opacity(0.7))
                        )
                }
            }
            
            // Status Text
            Text(statusText)
                .font(.subheadline)
                .foregroundColor(ColorTheme.primaryText.opacity(0.7))
                .multilineTextAlignment(.center)
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
    
    private var statusText: String {
        switch pomodoroManager.timerState {
        case .idle:
            return "Ready to start your \(pomodoroManager.currentSession.currentSessionType.rawValue.lowercased()) session"
        case .running:
            return "Stay focused! You're doing great."
        case .paused:
            return "Take a moment, then continue when ready"
        case .completed:
            return "Session completed! Great work."
        }
    }
}

struct TodayStatsCard: View {
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
                
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(ColorTheme.primaryButton)
            }
            
            HStack(spacing: 20) {
                StatItem(
                    title: "Sessions",
                    value: "\(pomodoroManager.totalSessionsToday)",
                    color: ColorTheme.primaryButton
                )
                
                StatItem(
                    title: "Focus Time",
                    value: pomodoroManager.formatDuration(pomodoroManager.totalFocusTimeToday),
                    color: ColorTheme.secondaryButton
                )
                
                StatItem(
                    title: "Average",
                    value: pomodoroManager.formatDuration(pomodoroManager.averageSessionLength),
                    color: ColorTheme.supportive
                )
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

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
            .environmentObject(PomodoroManager())
            .environmentObject(ThemeManager())
    }
}
