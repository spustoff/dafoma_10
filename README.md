# ColorHarmony: Blink 🎨

A beautiful iOS productivity app built with SwiftUI that combines task management, habit tracking, focus sessions, and advanced analytics with stunning color themes. Designed for iOS 15.6+ and crafted to enhance productivity through visual harmony.

## ✨ Features

### 🎨 Dynamic Color Themes
- **Ocean Harmony**: Professional blue tones for focused work
- **Sunset Vibes**: Warm orange and pink combination for creativity  
- **Night Mode**: Deep purples and blues for late-night productivity
- Real-time theme switching with smooth animations
- Color-coded task organization

### 📋 Advanced Task Management
- Create, edit, and organize tasks with beautiful interfaces
- Priority levels (Low, Medium, High) with color indicators
- Due date scheduling with smart formatting
- Task completion tracking with progress visualization
- Expandable task descriptions
- Filter tasks by status and priority
- Task linking with Pomodoro sessions

### 🎯 Habit Tracking System
- **Visual Habit Tracker**: Track daily habits with beautiful calendar views
- **Streak Counting**: Monitor consecutive days and build consistency
- **Progress Visualization**: Weekly and monthly heat maps
- **Customizable Icons**: Choose from 12 beautiful SF Symbols
- **Flexible Scheduling**: Set target days per week for each habit
- **Completion Statistics**: Detailed analytics for habit performance

### ⏱️ Pomodoro Focus Timer
- **Customizable Sessions**: Adjust work, short break, and long break durations
- **Smart Scheduling**: Automatic session type detection
- **Progress Tracking**: Visual circular progress indicators
- **Session History**: Track all completed focus sessions
- **Background Notifications**: Stay informed when sessions complete
- **Preset Configurations**: Quick setup with pre-defined timer settings
- **Focus Statistics**: Analyze daily and overall productivity patterns

### 📊 Advanced Analytics & Statistics
- **Comprehensive Dashboard**: Real-time overview of all productivity metrics
- **Detailed Statistics**: Task completion rates, habit consistency, focus time
- **Trend Analysis**: Visual charts showing productivity patterns over time
- **Performance Insights**: Identify your most productive habits and times
- **Progress Tracking**: Monitor improvements across different time frames
- **Data Visualization**: Beautiful charts and graphs for better understanding

### 🚀 Enhanced Productivity Features
- **Smart Dashboard**: Unified view of tasks, habits, and focus sessions
- **Quick Actions**: Fast access to common functions and shortcuts
- **Visual Analytics**: Circular progress indicators and detailed statistics
- **Smart Filtering**: Advanced filtering across all data types
- **Export & Import**: Complete data portability in JSON and CSV formats
- **Persistent Storage**: All data saved locally using UserDefaults

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
├── ContentView.swift              # Main interface with 6-tab navigation
├── Models/
│   ├── ColorTheme.swift          # Color scheme definitions
│   ├── Task.swift                # Task data model
│   ├── Habit.swift               # Habit tracking model
│   └── PomodoroSession.swift     # Focus session model
├── ViewModels/
│   ├── ThemeManager.swift        # Theme state management
│   ├── TaskManager.swift         # Task operations and persistence
│   ├── HabitManager.swift        # Habit tracking and analytics
│   └── PomodoroManager.swift     # Focus timer and session tracking
├── Views/
│   ├── OnboardingView.swift      # Multi-step onboarding
│   ├── AddTaskView.swift         # Task creation interface
│   ├── AddHabitView.swift        # Habit creation interface
│   ├── HabitTrackerView.swift    # Habit tracking main view
│   ├── PomodoroTimerView.swift   # Focus timer interface
│   ├── PomodoroSettingsView.swift # Timer configuration
│   ├── StatisticsView.swift      # Advanced analytics dashboard
│   ├── ExportDataView.swift      # Data export and sharing
│   ├── ThemeSelectorView.swift   # Theme selection interface
│   ├── DashboardComponents.swift # Enhanced dashboard widgets
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
- **6-Tab Navigation**: Dashboard, Tasks, Habits, Focus Timer, Statistics, Settings
- **Animated Onboarding**: Live theme previews and feature introductions
- **Enhanced Dashboard**: Real-time progress visualization across all features
- **Task Management**: Priority color coding with advanced filtering
- **Habit Tracking**: Visual calendar grids and streak counters
- **Pomodoro Timer**: Circular progress indicators with session management
- **Advanced Analytics**: Charts, trends, and productivity insights
- **Data Export**: Complete data portability and backup options
- **Theme Selector**: Live previews with smooth animations
- **Smooth Transitions**: Spring-based animations and micro-interactions

## 🤝 Contributing

This is a demonstration project showcasing SwiftUI best practices and modern iOS design patterns. Feel free to explore the code structure and implementation details.

## 📄 License

Created as a demonstration of modern iOS app development with SwiftUI.

## 🆕 What's New in Version 2.0

### Major Feature Additions:
- **🎯 Habit Tracking System**: Complete habit management with visual progress tracking
- **⏱️ Pomodoro Focus Timer**: Customizable focus sessions with statistics
- **📊 Advanced Analytics**: Comprehensive statistics and productivity insights
- **📤 Data Export**: Export your data in JSON or CSV formats
- **🎨 Enhanced UI**: 6-tab navigation with improved user experience

### Technical Improvements:
- **Better Architecture**: MVVM pattern with dedicated managers for each feature
- **Performance Optimized**: Efficient data handling and smooth animations
- **Expanded Storage**: UserDefaults integration for all new data types
- **Accessibility Ready**: VoiceOver support and accessibility enhancements

### App Store Readiness:
- **Unique Value Proposition**: Combines productivity with habit tracking and focus sessions
- **Substantial New Features**: 3 major new modules with deep functionality
- **Professional Polish**: Refined animations, interactions, and visual design
- **User Engagement**: Multiple ways to interact with and benefit from the app

---

**ColorHarmony: Blink v2.0** - The Ultimate Productivity Companion ✨ 