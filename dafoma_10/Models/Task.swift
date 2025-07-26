//
//  Task.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/26/25.
//

import Foundation

struct TaskItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var createdDate: Date = Date()
    var dueDate: Date?
    var priority: Priority = .medium
    var colorTheme: Int = 0 // Index for theme selection
    
    enum Priority: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var color: String {
            switch self {
            case .low: return "#2490ad"
            case .medium: return "#fbaa1a"
            case .high: return "#f0048d"
            }
        }
    }
} 