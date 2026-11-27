# COSMOS CINEMA

Flutter mobile app to discover movies and TV series, built with data from the [TMDB API](https://www.themoviedb.org/). It follows a Figma design and supports light and dark themes.

## Features

- **Login** with field validation (demo user only)
- **Home** with popular movies and series
- **Catalog** with search, type filter (All, Movies, Series) and category filter (Popular, Upcoming, Top rated)
- **Details** with overview, rating, cast and actor pages (bio and filmography)
- **Favorites**, **Watchlist** and **Seen** lists, saved on the device
- **Profile** with stats and a light/dark theme switch

## Demo credentials

`fabio@gmail.com` / `cosmos123`

## Tech

Flutter, `provider` (state), `http` (REST calls), `shared_preferences` (local storage).

## Structure

```
lib/
├── config/      # TMDB token (not committed)
├── data/        # Demo user
├── models/      # Movie, CastMember, Person
├── services/    # TMDB API calls
├── providers/   # Movies, user lists, theme
├── theme/       # Colors and light/dark themes
├── screens/     # One file per screen
└── widgets/     # Reusable components
```

## TMDB endpoints

`movie/popular`, `tv/popular`, `movie/upcoming`, `tv/on_the_air`, `movie/top_rated`, `tv/top_rated`, plus `credits`, `person/{id}` and `person/{id}/combined_credits` for cast and actors.

## Getting started

1. Run `flutter pub get`.
2. Get a free **API Read Access Token** from your [TMDB account](https://www.themoviedb.org/) (Settings, API).
3. Create `lib/config/api_keys.dart`:
   ```dart
   class ApiKeys {
     static const tmdbToken = 'YOUR_TOKEN_HERE';
   }
   ```
4. Run `flutter run`.

> Never commit `api_keys.dart`: it contains a personal token.

## Known limitations

The login is a demo (no real accounts), lists are stored only on the device, and the catalog loads only the first page of each category.

---
This product uses the TMDB API but is not endorsed or certified by TMDB.