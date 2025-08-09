//
//  PomodoroManager.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import SwiftUI
import Foundation
import AVFoundation
import UserNotifications

class PomodoroManager: ObservableObject {
    @Published var currentSession = PomodoroSession()
    @Published var timeRemaining: TimeInterval = 0
    @Published var timerState: TimerState = .idle
    @Published var sessions: [PomodoroSession] = []
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private let userDefaults = UserDefaults.standard
    private let sessionsKey = "SavedPomodoroSessions"
    
    init() {
        setupAudio()
        loadSessions()
        timeRemaining = currentSession.currentSessionDuration
        requestNotificationPermission()
    }
    
    func startTimer() {
        guard timerState != .running else { return }
        
        if timerState == .idle {
            timeRemaining = currentSession.currentSessionDuration
        }
        
        timerState = .running
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        
        scheduleNotification()
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        timerState = .paused
        cancelNotifications()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        timeRemaining = currentSession.currentSessionDuration
        cancelNotifications()
    }
    
    func resetTimer() {
        stopTimer()
        currentSession.completedSessions = 0
        timeRemaining = currentSession.currentSessionDuration
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            completeSession()
        }
    }
    
    private func completeSession() {
        timer?.invalidate()
        timer = nil
        timerState = .completed
        
        // Play completion sound
        playCompletionSound()
        
        // Update session data
        if currentSession.currentSessionType == .work {
            currentSession.totalFocusTime += currentSession.workDuration
        }
        
        currentSession.completedSessions += 1
        saveSession()
        
        // Setup next session
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setupNextSession()
        }
    }
    
    private func setupNextSession() {
        timerState = .idle
        timeRemaining = currentSession.currentSessionDuration
    }
    
    func customizeSession(work: TimeInterval, shortBreak: TimeInterval, longBreak: TimeInterval, sessionsUntilLongBreak: Int) {
        currentSession.workDuration = work
        currentSession.shortBreakDuration = shortBreak
        currentSession.longBreakDuration = longBreak
        currentSession.sessionsUntilLongBreak = sessionsUntilLongBreak
        
        if timerState == .idle {
            timeRemaining = currentSession.currentSessionDuration
        }
    }
    
    private func saveSession() {
        // Only save completed work sessions
        if currentSession.currentSessionType == .work && currentSession.completedSessions > 0 {
            sessions.append(currentSession)
            saveSessions()
        }
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            userDefaults.set(encoded, forKey: sessionsKey)
        }
    }
    
    private func loadSessions() {
        if let data = userDefaults.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([PomodoroSession].self, from: data) {
            sessions = decoded
        }
    }
    
    // MARK: - Audio Setup
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func playCompletionSound() {
        // Use system sound for completion
        AudioServicesPlaySystemSound(1016) // SMS tone
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    // MARK: - Notifications
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer"
        content.body = "\(currentSession.currentSessionType.rawValue) session completed!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeRemaining, repeats: false)
        let request = UNNotificationRequest(identifier: "PomodoroCompletion", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func cancelNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["PomodoroCompletion"])
    }
    
    // MARK: - Statistics
    var totalSessionsToday: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return sessions.filter { Calendar.current.startOfDay(for: $0.createdDate) == today }.count
    }
    
    var totalFocusTimeToday: TimeInterval {
        let today = Calendar.current.startOfDay(for: Date())
        return sessions
            .filter { Calendar.current.startOfDay(for: $0.createdDate) == today }
            .reduce(0) { $0 + $1.totalFocusTime }
    }
    
    var averageSessionLength: TimeInterval {
        guard !sessions.isEmpty else { return 0 }
        let totalTime = sessions.reduce(0) { $0 + $1.totalFocusTime }
        return totalTime / Double(sessions.count)
    }
    
    // MARK: - Formatting Helpers
    func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
