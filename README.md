# ShowRush

A movie ticket booking app built with Flutter. Browse movies currently showing in Bengaluru, pick a showtime, select seats on an interactive seat map, and complete a mock checkout through to a booking confirmation.

**Live demo:** https://samgabriel-here.github.io/movie-booking-app/

## Features

- Browse movies now showing, with posters, ratings, and synopses
- Search by title and filter by genre on the home screen
- Responsive movie grid that adapts from phone to desktop layouts
- View showtimes grouped by cinema
- Interactive seat selection with a seat-state legend and a live running total
- Order-summary checkout and a ticket-style booking confirmation with a generated booking ID
- Cohesive Material 3 design system with a shared theme and reusable components

## Tech stack

- [Flutter](https://flutter.dev) / Dart
- Mock, in-memory data (no backend) — see `lib/data/mock_data.dart`

## Project structure

```
lib/
  main.dart               # app entry point
  theme/
    app_theme.dart        # colors, typography, and shared Material 3 theme
  models/                 # data classes: Movie, Cinema, Showtime, Seat, Booking
  data/
    mock_data.dart        # mock movies, cinemas, and showtimes
  screens/                # one file per app screen (home, details, showtimes,
                          #   seat selection, checkout, confirmation)
  widgets/                # reusable widgets (movie card, seat tile)
```

## Getting started

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.

```bash
flutter pub get
flutter run -d chrome   # or any other connected device
```

Run tests and static analysis:

```bash
flutter test
flutter analyze
```

## Deploying to GitHub Pages

The live demo is published from the `gh-pages` branch. To redeploy after changes:

```bash
flutter build web --base-href /movie-booking-app/
# copy build/web contents to a gh-pages branch/worktree and push
```

## Roadmap

- Real movie poster artwork (e.g. via the TMDb API)
- Live showtimes and location detection
- Real backend with seat locking and authentication
