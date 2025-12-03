# KASA+ 💰

**KASA+** is a modern, efficient, and user-friendly money counting and safe management application designed for Android. It simplifies the process of counting cash, tracking safe inventory, and managing daily reconciliations for businesses and individuals.

## ✨ Features

*   **💵 Multi-Currency Support:** Seamlessly switch between Turkish Lira (TRY), US Dollar (USD), and Euro (EUR).
*   **🧮 Smart Money Counting:** Quickly count cash using an intuitive denomination-based interface.
*   **🏦 Safe Management:** Automatically track your safe's inventory ("Kasa"). Counts are added to the safe, and bank deposits are deducted.
*   **📉 Reconciliation:** Easily calculate differences between your counted cash, initial cash (avans), and target amounts.
*   **📜 History Tracking:** Keep a detailed record of all your counts and bank deposits.
*   **🏦 Bank Deposits:** Record money deposited into the bank, which is automatically deducted from your safe balance.
*   **📊 Statistics:** Visualize your financial trends with net total and difference charts.
*   **🌙 Dark Mode:** A sleek, eye-friendly dark theme with emerald accents.
*   **🌍 Localization:** Fully localized in English and Turkish.

## 📱 Screenshots

| Home Screen | Safe Inventory | History |
|:---:|:---:|:---:|
| *(Add screenshot here)* | *(Add screenshot here)* | *(Add screenshot here)* |

## 🚀 Getting Started

### Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
*   An Android device or emulator.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/kasa-plus.git
    cd kasa-plus
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

## 🛠️ Built With

*   **[Flutter](https://flutter.dev/)** - UI Toolkit
*   **[Provider](https://pub.dev/packages/provider)** - State Management
*   **[Shared Preferences](https://pub.dev/packages/shared_preferences)** - Local Data Persistence
*   **[FL Chart](https://pub.dev/packages/fl_chart)** - Charts and Graphs
*   **[Intl](https://pub.dev/packages/intl)** - Internationalization

## 📂 Project Structure

```
lib/
├── l10n/              # Localization files (ARB)
├── pages/             # Application screens (Home, Safe, History, etc.)
├── providers/         # State management logic
├── widgets/           # Reusable UI components
└── main.dart          # Entry point
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

