# ColorHarmony: Blink 🎨

A beautiful iOS productivity app built with SwiftUI that combines task management with stunning color themes. Designed for iOS 15.6+ and crafted to enhance productivity through visual harmony.

## ✨ Features

### 🎨 Dynamic Color Themes
- **Ocean Harmony**: Professional blue tones for focused work
- **Sunset Vibes**: Warm orange and pink combination for creativity  
- **Night Mode**: Deep purples and blues for late-night productivity
- Real-time theme switching with smooth animations
- Color-coded task organization

### 📋 Task Management
- Create, edit, and organize tasks with beautiful interfaces
- Priority levels (Low, Medium, High) with color indicators
- Due date scheduling with smart formatting
- Task completion tracking with progress visualization
- Expandable task descriptions
- Filter tasks by status and priority

### 🚀 Productivity Features
- **Dashboard**: Progress overview with completion rates
- **Visual Analytics**: Circular progress indicators and statistics
- **Quick Actions**: Fast access to common functions
- **Smart Filtering**: View tasks by status and priority
- **Persistent Storage**: Tasks saved locally using UserDefaults

### 🌟 User Experience
- **Onboarding Flow**: 4-step introduction to app features
- **Telegram-Style UI**: Clean, modern interface design
- **Smooth Animations**: Spring-based transitions and interactions
- **Haptic Feedback**: Enhanced tactile responses
- **App Store Compliant**: Designed to avoid rejection clauses 4.3, 4.3(a), and 2.1.3

## 🏗 Architecture

### Project Structure
```
dafoma_10/
├── ColorHarmonyApp.swift          # Main app entry point
├── ContentView.swift              # Main interface with tab navigation
├── Models/
│   ├── ColorTheme.swift          # Color scheme definitions
│   └── Task.swift                # Task data model
├── ViewModels/
│   ├── ThemeManager.swift        # Theme state management
│   └── TaskManager.swift         # Task operations and persistence
├── Views/
│   ├── OnboardingView.swift      # Multi-step onboarding
│   ├── AddTaskView.swift         # Task creation interface
│   ├── ThemeSelectorView.swift   # Theme selection interface
│   ├── DashboardComponents.swift # Dashboard cards and widgets
│   └── TaskComponents.swift      # Task list and management
└── UIComponents/
    ├── CustomButton.swift        # Reusable button component
    └── ColorBlock.swift          # Color display component
```

### Design Patterns
- **MVVM Architecture**: Clean separation of concerns
- **ObservableObject**: Reactive state management
- **Environment Objects**: Dependency injection
- **SwiftUI Composition**: Reusable component architecture

## 🎨 Color Scheme

### Background Colors
- **Main**: `#2490ad` - Ocean Blue
- **Accent 1**: `#3c166d` - Deep Purple  
- **Accent 2**: `#1a2962` - Navy Blue

### Interactive Elements
- **Primary**: `#fbaa1a` - Golden Orange
- **Secondary**: `#f0048d` - Vibrant Pink

### Supporting Colors
- **Supportive**: `#01ff00` - Electric Green
- **Neutral**: `#f7f7f7` - Soft Gray

## 🛠 Technical Requirements

- **iOS Version**: 15.6+
- **Framework**: SwiftUI
- **Language**: Swift 5.0+
- **Dependencies**: None (native iOS only)
- **Storage**: UserDefaults for local persistence
- **Categories**: Business, Lifestyle, Productivity

## 🚀 Getting Started

1. **Clone or Download** the project
2. **Open** `dafoma_10.xcodeproj` in Xcode
3. **Select** your target device or simulator
4. **Build and Run** (⌘+R)

### First Launch
- Experience the 4-step onboarding process
- Explore the theme switching functionality
- Create your first task to see the productivity features

## 🎯 App Store Compliance

- **Unique Value Proposition**: Combines productivity with visual design
- **Original Content**: Custom UI components and interactions
- **Substantial Functionality**: Task management with theme integration
- **Professional Quality**: Polished animations and user experience

## 🔧 Customization

### Adding New Themes
1. Open `ViewModels/ThemeManager.swift`
2. Add new `ThemeSet` to the `themes` array
3. Define colors using the existing color scheme structure

### Extending Task Features
1. Modify `Models/Task.swift` for new properties
2. Update `ViewModels/TaskManager.swift` for new operations
3. Enhance UI components in `Views/TaskComponents.swift`

## 📱 Screenshots & Demo

The app features:
- Animated onboarding with live theme previews
- Dashboard with progress visualization
- Task management with priority color coding
- Theme selector with live previews
- Smooth transitions and micro-interactions

## 🤝 Contributing

This is a demonstration project showcasing SwiftUI best practices and modern iOS design patterns. Feel free to explore the code structure and implementation details.

## 📄 License

Created as a demonstration of modern iOS app development with SwiftUI.

---

**ColorHarmony: Blink** - Where productivity meets visual beauty ✨ 