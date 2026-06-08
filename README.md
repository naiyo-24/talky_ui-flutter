# Talky Flutter

A comprehensive, multi-language news and community application built with Flutter. Talky delivers localized news, YouTube video integrations, and community engagement features (like polls) with a seamless user experience.

## Key Features

- **Multi-Language Support**: Real-time language switching (English, Bengali, Hindi) using `AppLocalizations` and Riverpod state management.
- **News Aggregation Pipeline**: Automated news ingestion from diverse RSS and JSON sources (Politics, Tech, Business, Sports, etc.) powered by backend Python scripts (`generate_news.py`).
- **Centralized Database Architecture**: Efficient local caching and data handling using a centralized database pattern for translated content.
- **Modern Navigation**: Seamless deep linking and routing handled by `GoRouter`, including proper back-button interception using `PopScope`.
- **Media Integration**: Embedded YouTube news reels using `youtube_player_iframe` and optimized image caching with `cached_network_image`.
- **Community Engagement**: Dedicated community tab with interactive polls.
- **Local Storage**: Fast, secure on-device caching utilizing `hive_flutter`.

## Tech Stack

- **Framework:** Flutter
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Local Storage:** Hive
- **Localization:** Flutter Localizations (`.arb` files)
- **Media:** YouTube Player Iframe, Cached Network Image
- **Animations:** Flutter Animate

## Project Structure

```text
lib/
├── main.dart
├── core/                  # Core application logic, configuration, and utilities
│   ├── constants/         # App constants, UI configurations
│   ├── network/           # API clients and interceptors
│   ├── router/            # GoRouter configuration (app_router.dart)
│   ├── storage/           # Hive database initialization
│   ├── theme/             # Light/Dark mode themes
│   └── utils/             # Helper functions and extensions
├── features/              # Feature-based modules (screens, widgets, providers, repos)
│   ├── article/           # News article reading experience
│   ├── bookmark/          # Saved articles
│   ├── categories/        # News categories (Tech, Sports, etc.)
│   ├── community/         # Polls and user engagement
│   ├── home/              # Main news feed
│   ├── language/          # Language selection and localization onboarding
│   ├── search/            # News search functionality
│   ├── settings/          # User preferences
│   ├── splash/            # App initialization screen
│   └── videos/            # YouTube news reels
└── shared/                # Shared widgets and models
    ├── models/
    └── widgets/
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable recommended)
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd talky_Flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Automated Data Pipeline
The application relies on a data pipeline for fetching and processing news. The `scripts/generate_news.py` script aggregates content from various sources, maps categories, and produces the necessary JSON files (`assets/json/news.json`) to populate the app's initial state.
