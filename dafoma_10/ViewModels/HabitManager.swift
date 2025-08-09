//
//  HabitManager.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import SwiftUI
import Foundation

class HabitManager: ObservableObject {
    @Published var habits: [Habit] = []
    
    private let userDefaults = UserDefaults.standard
    private let habitsKey = "SavedHabits"
    
    init() {
        loadHabits()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
    }
    
    func toggleHabitCompletion(_ habit: Habit, for date: Date = Date()) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].toggleCompletionForDate(date)
            saveHabits()
        }
    }
    
    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            userDefaults.set(encoded, forKey: habitsKey)
        }
    }
    
    private func loadHabits() {
        if let data = userDefaults.data(forKey: habitsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        }
    }
    
    var activeHabits: [Habit] {
        habits.filter { $0.isActive }
    }
    
    var totalHabitsCompleted: Int {
        habits.reduce(0) { $0 + $1.completions.count }
    }
    
    var averageCompletionRate: Double {
        guard !habits.isEmpty else { return 0 }
        let totalRate = habits.reduce(0.0) { $0 + $1.completionRate }
        return totalRate / Double(habits.count)
    }
    
    func habitsCompletedToday() -> Int {
        let today = Date()
        return activeHabits.filter { $0.isCompletedForDate(today) }.count
    }
    
    func getWeeklyData(for habit: Habit) -> [Bool] {
        let calendar = Calendar.current
        let today = Date()
        var weekData: [Bool] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                weekData.append(habit.isCompletedForDate(date))
            }
        }
        
        return weekData.reversed()
    }
    
    func getMonthlyData(for habit: Habit) -> [Bool] {
        let calendar = Calendar.current
        let today = Date()
        var monthData: [Bool] = []
        
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                monthData.append(habit.isCompletedForDate(date))
            }
        }
        
        return monthData.reversed()
    }
}
