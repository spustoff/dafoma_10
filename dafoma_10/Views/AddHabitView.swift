//
//  AddHabitView.swift
//  ColorHarmony: Blink
//
//  Created by Вячеслав on 7/31/25.
//

import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var targetDaysPerWeek = 7
    @State private var selectedIcon = HabitIcon.star
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
                        
                        Text("New Habit")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        CustomButton(
                            title: "Save",
                            action: saveHabit,
                            style: .primary,
                            size: .small,
                            isEnabled: !name.isEmpty
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
                            // Name input
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Habit Name")
                                    .font(.headline)
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                TextField("Enter habit name", text: $name)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            // Description input
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline)
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                TextField("Enter habit description", text: $description)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            // Target days per week
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Target Days per Week")
                                    .font(.headline)
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                HStack {
                                    Text("\(targetDaysPerWeek) days")
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Spacer()
                                    
                                    Stepper("", value: $targetDaysPerWeek, in: 1...7)
                                        .labelsHidden()
                                        .accentColor(ColorTheme.primaryButton)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorTheme.neutral.opacity(0.9))
                                )
                            }
                            
                            // Icon selection
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Icon")
                                    .font(.headline)
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                                    ForEach(HabitIcon.allCases, id: \.self) { icon in
                                        HabitIconButton(
                                            icon: icon,
                                            isSelected: selectedIcon == icon
                                        ) {
                                            selectedIcon = icon
                                        }
                                    }
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
    
    private func saveHabit() {
        let newHabit = Habit(
            id: UUID(), name: name,
            description: description,
            targetDaysPerWeek: targetDaysPerWeek,
            colorTheme: selectedColorTheme,
            icon: selectedIcon.rawValue
        )
        
        habitManager.addHabit(newHabit)
        dismiss()
    }
}

struct HabitIconButton: View {
    let icon: HabitIcon
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon.rawValue)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.secondaryText)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? ColorTheme.primaryButton : ColorTheme.neutral.opacity(0.3))
                    )
                
                Text(icon.displayName)
                    .font(.caption2)
                    .foregroundColor(ColorTheme.primaryText)
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
            .environmentObject(HabitManager())
            .environmentObject(ThemeManager())
    }
}
