//
//  PomodoroSession.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import Foundation

struct PomodoroSession: Identifiable, Codable {
    let id = UUID()
    var workDuration: TimeInterval = 25 * 60 // 25 minutes
    var shortBreakDuration: TimeInterval = 5 * 60 // 5 minutes
    var longBreakDuration: TimeInterval = 15 * 60 // 15 minutes
    var sessionsUntilLongBreak: Int = 4
    
    var completedSessions: Int = 0
    var totalFocusTime: TimeInterval = 0
    var createdDate: Date = Date()
    var linkedTaskId: UUID? // Link to specific task
    
    var currentSessionType: SessionType {
        if completedSessions == 0 {
            return .work
        } else if completedSessions % sessionsUntilLongBreak == 0 {
            return .longBreak
        } else {
            return completedSessions % 2 == 0 ? .work : .shortBreak
        }
    }
    
    var currentSessionDuration: TimeInterval {
        switch currentSessionType {
        case .work:
            return workDuration
        case .shortBreak:
            return shortBreakDuration
        case .longBreak:
            return longBreakDuration
        }
    }
}

enum SessionType: String, CaseIterable, Codable {
    case work = "Work"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
    
    var icon: String {
        switch self {
        case .work: return "brain.head.profile"
        case .shortBreak: return "cup.and.saucer.fill"
        case .longBreak: return "bed.double.fill"
        }
    }
    
    var color: String {
        switch self {
        case .work: return "#f0048d"
        case .shortBreak: return "#fbaa1a"
        case .longBreak: return "#2490ad"
        }
    }
}

enum TimerState {
    case idle
    case running
    case paused
    case completed
}
