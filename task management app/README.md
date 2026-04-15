# 📝 Task Management App

A feature-rich **Flutter** task management application with biometric security, productivity analytics, and smart notifications.

---

## ✨ Features

- ✅ **Task Management** — Create, update, and delete tasks with priorities and due dates
- 🔐 **Biometric Security** — Fingerprint / Face ID authentication
- 📊 **Productivity Analytics** — Visual insights into your task completion trends
- 🔔 **Smart Notifications** — Reminders for upcoming and overdue tasks
- 🎨 **Modern UI** — Clean, intuitive interface with dark mode support

---

## 📱 Screenshots

> Coming soon

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- Android Studio / VS Code
- Android emulator or physical device

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/task-management-app.git

# Navigate to the project directory
cd task-management-app

# Get dependencies
flutter pub get

# Run the app
flutter run
```

---

## 🏗️ Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/
│   └── task.dart              # Task data model
├── providers/
│   └── task_provider.dart     # State management
├── screens/
│   ├── home_screen.dart       # Main task list screen
│   └── analytics_screen.dart  # Productivity analytics
├── services/
│   ├── biometric_service.dart # Biometric authentication
│   └── notification_service.dart # Push notifications
└── widgets/
    ├── task_card.dart          # Task item UI
    ├── add_task_bottom_sheet.dart # Add/edit task form
    └── progress_header.dart   # Progress summary widget
```

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI framework |
| Provider | State management |
| local_auth | Biometric authentication |
| flutter_local_notifications | Push notifications |

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 🙋 Author

Built with ❤️ using Flutter
