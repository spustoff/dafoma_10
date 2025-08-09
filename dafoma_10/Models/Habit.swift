//
//  Habit.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import Foundation
import SwiftUI

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var targetDaysPerWeek: Int = 7
    var colorTheme: Int = 0
    var icon: String = "star.fill"
    var createdDate: Date = Date()
    var isActive: Bool = true
    
    // Track completion for specific dates
    var completions: [String] = [] // Stores dates as strings (YYYY-MM-DD)
    
    var streak: Int {
        calculateCurrentStreak()
    }
    
    var completionRate: Double {
        let totalSeconds = Date().timeIntervalSince(createdDate)
        let daysSinceCreation = max(1, Int(totalSeconds / 86_400)) // 86,400 seconds in a day
        return Double(completions.count) / Double(daysSinceCreation)
    }
    
    private func calculateCurrentStreak() -> Int {
        let calendar = Calendar.current
        var currentStreak = 0
        var currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        while currentStreak < completions.count {
            let dateString = dateFormatter.string(from: currentDate)
            if completions.contains(dateString) {
                currentStreak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return currentStreak
    }
    
    func isCompletedForDate(_ date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return completions.contains(dateString)
    }
    
    mutating func toggleCompletionForDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let index = completions.firstIndex(of: dateString) {
            completions.remove(at: index)
        } else {
            completions.append(dateString)
        }
    }
}

enum HabitIcon: String, CaseIterable {
    case star = "star.fill"
    case heart = "heart.fill"
    case leaf = "leaf.fill"
    case brain = "brain.head.profile"
    case book = "book.fill"
    case dumbbell = "dumbbell.fill"
    case bed = "bed.double.fill"
    case drop = "drop.fill"
    case flame = "flame.fill"
    case target = "target"
    case checkmark = "checkmark.circle.fill"
    case moon = "moon.fill"
    
    var displayName: String {
        switch self {
        case .star: return "Goal"
        case .heart: return "Health"
        case .leaf: return "Nature"
        case .brain: return "Learning"
        case .book: return "Reading"
        case .dumbbell: return "Exercise"
        case .bed: return "Sleep"
        case .drop: return "Water"
        case .flame: return "Energy"
        case .target: return "Target"
        case .checkmark: return "Complete"
        case .moon: return "Night"
        }
    }
}
