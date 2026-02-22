# Netflix Clone – Flutter Application

## Project Overview
This project is a Netflix-inspired mobile application developed using Flutter. The app integrates with The Movie Database (TMDB) API to fetch real-time movie and TV show data. Users can browse trending content, view upcoming movies, search titles, and explore TV series seasons and episodes.

## Core Features
- Now Playing Movies
- Trending Movies (Daily)
- Upcoming Movies (New & Hot Section)
- Top Rated Movies
- Popular TV Shows
- Movie Search Functionality
- Movie Detail Screen with Recommendations
- TV Detail Screen with Season Dropdown
- Episode Listing per Season
- Responsive Netflix-style UI
- Bottom Navigation Bar with Tab Controller
- TMDB API Integration using Dio

## Technology Stack
- Flutter (UI Framework)
- Dart Programming Language
- Dio (HTTP Client for API Calls)
- CachedNetworkImage (Optimized Image Loading)
- Intl (Date Formatting)
- Material & Cupertino Widgets
- TMDB REST API

## Project Architecture
The project follows a structured and modular architecture separating models, services, and UI layers. API calls are handled inside a dedicated service class using Dio. Data models parse JSON responses from TMDB endpoints. UI components consume parsed models via FutureBuilder.

## API Configuration
This application uses The Movie Database (TMDB) API. To configure the API access, create an account at https://www.themoviedb.org/ and generate a Read Access Token. Add your token inside the `api_key.dart` file.

## How To Run The Project
- Clone the repository from GitHub.
- Navigate into the project directory.
- Run: `flutter pub get`
- Run: `flutter run`

## Future Improvements
- Trailer integration using YouTube API
- Authentication and user profiles
- Favorites / My List functionality
- State management integration (Bloc / Riverpod)
- Pagination support for infinite scrolling
- Improved animations and transitions
- Multi-search support (Movies + TV)

## Author
- Tamer
- Flutter Developer
