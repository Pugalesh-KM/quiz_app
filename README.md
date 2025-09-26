# 📝 quiz_app

A Flutter-based **Quiz application** that allows users to take quizzes with local data storage using Hive.  
Built using **Flutter**, **BLoC**, **Hive**, and **Equatable** for state management and persistence.

---

## 🚀 Features

- 📝 Take quizzes with multiple-choice questions
- 💾 Persistent storage of scores and progress using Hive
- 🔄 State management with **BLoC/Cubit**
- ⚡ Lightweight, fast, and offline-ready
- 📦 Modular and scalable architecture

---

## 📦 Dependencies

Key packages used in this project:

- [`bloc`](https://pub.dev/packages/bloc) → State management
- [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) → Flutter integration for BLoC
- [`hive`](https://pub.dev/packages/hive) → Local database for storing quiz data
- [`hive_flutter`](https://pub.dev/packages/hive_flutter) → Flutter integration for Hive
- [`equatable`](https://pub.dev/packages/equatable) → Simplifies value comparisons for state management
- [`path_provider`](https://pub.dev/packages/path_provider) → Required for Hive storage path
- [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) → iOS-style icons

### Dev Dependencies

- [`build_runner`](https://pub.dev/packages/build_runner) → Code generation
- [`hive_generator`](https://pub.dev/packages/hive_generator) → Generate TypeAdapters for Hive models
- [`flutter_lints`](https://pub.dev/packages/flutter_lints) → Linting rules

---

## 🏗️ Project Structure

- `core/` → Services, constants, utility functions
- `features/` → Quiz modules (models, UI, Hive adapters)
- `shared/` → Common widgets, themes, and helpers
- `main.dart` → Application entry point

---

## 📱 Download APK

👉 [Click here to download quiz_app APK](https://github.com/Pugalesh-KM/quiz_app/blob/main/assets/apk/quiz_app.apk)

---

## ▶️ Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/Pugalesh-KM/quiz_app.git
cd quiz_app
