# Expense Tracker

A clean Flutter expense tracker for recording income and expenses, monitoring monthly cash flow, setting budgets, and reviewing spending insights.

## Features
- Dashboard with balance, income, and expense summaries
- Add, edit, and delete transactions
- Categories for common spending and income sources
- Search and filter transaction history
- Monthly spending chart and category breakdown
- Monthly category budgets with progress indicators
- Light and dark themes
- Local SQLite persistence (works offline)
- Basic input validation and widget tests

## Tech stack
Flutter, Dart, Provider, SQLite (sqflite), fl_chart, intl, and shared_preferences.

## Run locally
1. Install the Flutter SDK and an Android/iOS development toolchain.
2. Clone this repository.
3. Run `flutter pub get`.
4. Run `flutter run`.

## Test and analyze
```bash
flutter analyze
flutter test
```

## Project structure
```
lib/
  data/          SQLite database and repositories
  models/        Transaction and budget models
  providers/     App state
  screens/       Dashboard, history, budgets, settings
  theme/         App themes
  utils/         Formatting helpers
  widgets/       Reusable UI components
test/            Widget and model tests
```

All financial data is stored locally on the device. This project is an educational tracker and does not connect to bank accounts.
