# GharCare Mobile App

GharCare is a home service booking mobile application built using Flutter. The app allows users to easily browse and book home services such as cleaning, plumbing, electrical work, and other household services. It provides a simple and convenient way for users to manage home service requests directly from their mobile devices.

## Features

- User registration and login
- Browse available home services
- View service details
- Book home services
- Save favourite services
- Local data caching

## Architecture

The application follows Clean Architecture which separates the project into three main layers:

### Presentation Layer

This layer contains the user interface and handles user interactions. It includes screens, widgets, and state management using Riverpod.

### Domain Layer

The domain layer contains the core business logic of the application. It includes entities, repository interfaces, and use cases that define how the application works.

### Data Layer

The data layer is responsible for handling data from external sources such as APIs and local storage. It includes models, repository implementations, and data sources.

## Technologies Used

- Flutter
- Riverpod (State Management)
- Hive (Local Database)
- MongoDB (Backend Database)
- REST API

## Project Structure

```
lib/
 ├── data
 ├── domain
 ├── presentation
 ├── core
 └── main.dart
```

## Installation

1. Clone the repository

```
git clone https://github.com/your-username/gharcare-mobile-app.git
```

2. Navigate to the project directory

```
cd gharcare-mobile-app
```

3. Install dependencies

```
flutter pub get
```

4. Run the application

```
flutter run
```

## Backend

The mobile app connects to a REST API built with Node.js and Express, using MongoDB as the database.

## Author

Vinayak Shrestha
