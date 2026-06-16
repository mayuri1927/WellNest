# WellNest - Family Healthcare Management App
![WellNest](https://img.shields.io/badge/WellNest-Family%20Healthcare-4CAF50?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-3.44.2-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?style=for-the-badge&logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-10.0.0-FFCA28?style=for-the-badge&logo=firebase)
WellNest is a comprehensive family healthcare management application built with Flutter and Firebase. It helps families track workouts, meals, medicines, doctor appointments, and medical documents all in one place.
## Features
### 1. Authentication
- Email/Password registration and login
- Password reset functionality
- Session management
- Profile management
### 2. Workout Tracker
- Log workouts with type, duration, calories, and notes
- Support for multiple workout types (Cardio, Strength, HIIT, Yoga, etc.)
- View workout history
- Track progress over time
### 3. Meal Tracker
- Log meals with name, calories, meal type, and notes
- Support for Breakfast, Lunch, Dinner, and Snacks
- Daily calorie tracking
- Meal history and insights
### 4. Medicine Reminder
- Add medicines with dosage, frequency, and timing
- Set reminders for medicine intake
- Track medicine history
- Support for multiple dosage units (tablet, capsule, ml, mg, drops)
### 5. Doctor Appointment Manager
- Schedule doctor appointments with date, time, and location
- Add doctor details and notes
- View upcoming and past appointments
- Appointment reminders
### 6. Medical Document Vault
- Securely store medical documents
- Support for multiple document types (Prescriptions, Reports, Lab Results, Insurance)
- Firebase Storage integration for file uploads
- Document categorization and search
### 7. Dashboard
- Overview of all family health activities
- Quick access to all modules
- Recent activity summary
- Family member management
## Architecture
This project follows **Clean Architecture** with **MVVM** pattern:
lib/
├── core/
│   ├── constants/       # App-wide constants
│   ├── errors/          # Exception and failure handling
│   ├── navigation/     # GoRouter configuration
│   ├── theme/          # App theme configuration
│   └── utils/          # Utilities and validators
├── data/
│   ├── datasources/    # Firebase data sources
│   ├── models/         # Data models (JSON serialization)
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   └── repositories/   # Repository interfaces
└── presentation/
    ├── providers/      # Riverpod providers
    ├── screens/       # UI screens
    └── widgets/        # Reusable widgets
### State Management
- **Riverpod** for reactive state management
- Provider-based architecture for dependency injection
- AsyncNotifier for async operations
### Backend Services
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - File storage for documents
- **Firebase Messaging** - Push notifications
## Technology Stack
| Category | Technology |
|----------|------------|
| Framework | Flutter 3.44.2 |
| Language | Dart 3.12.2 |
| State Management | flutter_riverpod ^2.6.1 |
| Navigation | go_router ^14.8.1 |
| Backend | Firebase (Auth, Firestore, Storage, Messaging) |
| Local Notifications | flutter_local_notifications ^18.0.1 |
| Calendar | table_calendar ^3.1.3 |
| Image Handling | cached_network_image, image_picker |
| File Handling | file_picker, path_provider |
| Testing | flutter_test, mocktail |
## Getting Started
### Prerequisites
- Flutter SDK 3.44.2 or higher
- Dart SDK 3.12.2 or higher
- Xcode (for iOS development)
- Android Studio (for Android development)
- Firebase project with enabled services
### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/mayuri1927/WellNest.git
   cd WellNest
2. Install dependencies
      flutter pub get
   
3. Configure Firebase
      # Install Firebase CLI if not already installed
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Configure Firebase for your project
   flutterfire configure
   
4. Update Firebase Configuration
   Replace the contents of lib/firebase_options.dart with your project's configuration.
5. Run the app
      # Run in debug mode
   flutter run
   
   # Run in release mode
   flutter run --release
   
Firebase Console Setup
1. Create a new Firebase project
2. Enable Authentication with Email/Password provider
3. Enable Cloud Firestore in test mode (or configure rules)
4. Enable Storage in test mode (or configure rules)
5. Enable Cloud Messaging for push notifications
6. Download configuration files:
   - iOS: GoogleService-Info.plist
   - Android: google-services.json
Project Structure
lib/
├── main.dart                     # App entry point
├── firebase_options.dart        # Firebase configuration
├── core/
│   ├── constants/
│   │   ├── app_constants.dart    # App-wide constants
│   │   └── firebase_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart       # Custom exceptions
│   │   └── failures.dart         # Failure classes
│   ├── navigation/
│   │   └── app_router.dart       # GoRouter configuration
│   ├── theme/
│   │   └── app_theme.dart        # Material theme
│   └── utils/
│       ├── date_time_utils.dart  # Date/time helpers
│       └── validators.dart       # Input validation
├── data/
│   ├── datasources/
│   │   ├── auth_datasource.dart      # Auth operations
│   │   ├── firestore_datasource.dart # Firestore operations
│   │   └── storage_datasource.dart   # Storage operations
│   ├── models/
│   │   ├── appointment_model.dart
│   │   ├── document_model.dart
│   │   ├── family_member_model.dart
│   │   ├── meal_model.dart
│   │   ├── medicine_model.dart
│   │   ├── user_model.dart
│   │   └── workout_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── workout_repository_impl.dart
│       ├── meal_repository_impl.dart
│       ├── medicine_repository_impl.dart
│       ├── appointment_repository_impl.dart
│       └── document_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── appointment.dart
│   │   ├── document.dart
│   │   ├── family_member.dart
│   │   ├── meal.dart
│   │   ├── medicine.dart
│   │   ├── user.dart
│   │   └── workout.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── workout_repository.dart
│       ├── meal_repository.dart
│       ├── medicine_repository.dart
│       ├── appointment_repository.dart
│       └── document_repository.dart
└── presentation/
    ├── providers/
    │   ├── auth_provider.dart
    │   ├── workout_provider.dart
    │   ├── meal_provider.dart
    │   ├── medicine_provider.dart
    │   ├── appointment_provider.dart
    │   └── document_provider.dart
    ├── screens/
    │   ├── auth/
    │   │   ├── login_screen.dart
    │   │   └── register_screen.dart
    │   ├── dashboard/
    │   │   └── dashboard_screen.dart
    │   ├── workout/
    │   │   ├── workout_list_screen.dart
    │   │   └── workout_form_screen.dart
    │   ├── meal/
    │   │   ├── meal_list_screen.dart
    │   │   └── meal_form_screen.dart
    │   ├── medicine/
    │   │   ├── medicine_list_screen.dart
    │   │   └── medicine_form_screen.dart
    │   ├── appointment/
    │   │   ├── appointment_list_screen.dart
    │   │   └── appointment_form_screen.dart
    │   └── document/
    │       ├── document_list_screen.dart
    │       └── document_form_screen.dart
    └── widgets/
        ├── common/
        │   └── custom_widgets.dart
        └── loading_widget.dart
Data Models
User
- uid: String
- email: String
- displayName: String
- createdAt: DateTime
- familyMembers: List<FamilyMember>
Workout
- id: String
- userId: String
- type: WorkoutType (Cardio, Strength, Flexibility, HIIT, Yoga, Sports, Other)
- duration: int (minutes)
- caloriesBurned: int
- notes: String
- date: DateTime
- createdAt: DateTime
Meal
- id: String
- userId: String
- name: String
- mealType: MealType (Breakfast, Lunch, Dinner, Snack)
- calories: int
- notes: String
- date: DateTime
- createdAt: DateTime
Medicine
- id: String
- userId: String
- name: String
- dosage: double
- unit: MedicineUnit (tablet, capsule, ml, mg, drops, injection)
- frequency: String
- reminderTime: DateTime
- notes: String
- isActive: bool
- createdAt: DateTime
Appointment
- id: String
- userId: String
- doctorName: String
- specialty: String
- dateTime: DateTime
- location: String
- notes: String
- createdAt: DateTime
Document
- id: String
- userId: String
- title: String
- documentType: DocumentType (Prescription, Medical Report, Lab Results, Insurance, ID Proof, Other)
- fileUrl: String
- fileName: String
- notes: String
- uploadedAt: DateTime
- createdAt: DateTime
Testing
Run unit tests:
flutter test
Run tests with coverage:
flutter test --coverage
Build
iOS
# Build for simulator
flutter build ios --simulator --no-codesign
# Build for production
flutter build ios --release
Android
# Build for debug
flutter build apk --debug
# Build for release
flutter build apk --release
Contributing
1. Fork the repository
2. Create a feature branch (git checkout -b feature/amazing-feature)
3. Commit your changes (git commit -m 'Add amazing feature')
4. Push to the branch (git push origin feature/amazing-feature)
5. Open a Pull Request
License
This project is licensed under the MIT License - see the LICENSE file for details.
Acknowledgments
- Flutter team for the amazing framework
- Firebase for the comprehensive backend services
- All open-source package maintainers
Support
For support, email support@wellnest.app or create an issue on GitHub.
---
Made with ❤️ for families who care about health
