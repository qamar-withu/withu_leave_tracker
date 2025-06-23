# Withu Leave Tracker 📱

A comprehensive leave management application built with Flutter using Domain-Driven Design (DDD) architecture. This app enables teams to efficiently manage leave requests, track team calendars, and handle leave approvals.

## ✨ Features

- **User Authentication** - Secure login/signup with Firebase Auth
- **Leave Request Management** - Create, view, and manage leave requests
- **Team Calendar** - View team-wide leave schedules and availability
- **Leave Approval Workflow** - Managers can approve/reject leave requests
- **Team & Project Management** - Organize users by teams and projects
- **Profile Management** - Update user profiles and preferences
- **Multi-flavor Support** - Dev, QA, Staging, and Production environments
- **Real-time Updates** - Live synchronization with Firebase Firestore

## 🏗️ Architecture

This project follows Domain-Driven Design (DDD) principles with Clean Architecture.

## 🚀 Getting Started

### Prerequisites

- Flutter 3.19.0 or higher
- Dart 3.3.0 or higher
- Firebase account and project setup
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/withu_leave_tracker.git
   cd withu_leave_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Firebase Setup**
   - Follow the instructions in `FIREBASE_SETUP.md`
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

5. **Run the app**
   ```bash
   # Development
   flutter run --flavor dev -t lib/flavors/dev/main_dev.dart
   
   # Production
   flutter run --flavor prod -t lib/flavors/prod/main_prod.dart
   ```

## 📱 App Features

### For Employees:
- Submit leave requests with dates, type, and reason
- View personal leave history and status
- Check team calendar for leave planning
- Update profile information

### For Managers:
- Review and approve/reject leave requests
- View team leave schedules
- Manage team members and projects
- Access comprehensive leave analytics

## 🏛️ Architecture Layers
## 🏛️ Architecture Layers

To know more about Domain Driven Design in flutter please visit:
https://resocoder.com/2020/03/09/flutter-firebase-ddd-course-1-domain-driven-design-principles/

There are 4 layers in the project architecture:

1. ### Presentation
   - It is the outer most layer, where we are handling all UI of app.
   - It is connected with Application Layer to trigger events using Bloc and receive the response from Application layer.
   - Every module contains a folder in each layer and try to keep every file in its specific folder e.g Home-> home.dart.
2. ### Application
   - This is second layer in the app where we handle all business logic using blocs.
   - Every module should have a bloc to manage its state in presentation layer.
   - Every module should have a folder e.g Application-> auth -> auth_bloc.dart, auth_event.dart, auth_state.dart
   - Create states in [moudle name]\_state.dart
   - Create events in [module name]\_event.dart
   - Place events and change of states in [module_name]\_bloc.dart
3. ### Domain
   - This is very important layer which is responsible to deliver either an entity or a failure to application layer.
   - This layer contains Value Objects, Value Transformers Entities and Facades.
   - Facade is basically an abstract class containing all possible events to be used in Repository layer.
   - Every module should have a folder name 'entities' to include all entities and 'repository' to include abstract class, see example code in project, and can have extra two folders if necessary (values, errors) to handle values objects and failures.
4. ### Infrastructure
   - This is the outer most layer from bottom.
   - This is responsible to communicate to out side world e.g. API.
   - This layer is responsible to handle Dto's and Exceptions which could occur.
   - Try and Catch are only used in this layer to handle exceptions.
   - Exceptions are further sent to Domain layer to convert them to failures and pass it further to upper layers untill Presentation.
   - This layer contains necessarily three folders
     - Dto (to include freezed dto for an entity)
     - datasource (to include remote datasouces along with firebase query)
     - repository (to define the functions declared in domain layer's facade, all try-catch defined in this instead of datasource)


### config.dart

- This file is responsible to handle all configurations related to app i-e endpoints for multiple flavors.

### routes.dart

- This file is responsible to handle routes of all screens being used in Presentation layer. Routes are created using go_router

### core

- Every layer has a core folder which is shared component in a layer. If all modules have to share something between each other, that should be included in core folder e.g button.dart, errors.dart, value_objects.dart

### locator.dart

- This file is very important as it registers all singleton to be used gloablly. Try to register every thing manually which is injected in app. e.g blocs, repostiories


### Flavor

| Flavor  | Package name                             | App Name         |
| ------- | ---------------------------------------- | -----------------|
| Dev     | com.withuleavetracker.dev                | Withu LT Dev     |
| Qa      | com.withuleavetracker.qa                 | WithuLT Qa       |
| Staging | com.withuleavetracker.staging            | WithuLT Stage    |
| Prod    | com.withuleavetracker.app                | Withu LT         |
                       

### Add Flavor to Firebase

1. firebase use --add e.g. uat

2. firebase init hosting:github, which will create secrets under: https://github.com/moregooddays/flutter-app/settings/secrets/actions

3. ignore the generated yml files, and copy existing environments yml settings and edit (e.g. qa, staging)

4. Deploy the first firebase deploy

### Auto build json_serializable, freezed

dart run build_runner watch --delete-conflicting-outputs

### Run app

- flutter run --flavor dev -t lib/flavors/dev/main_dev.dart
- flutter run --flavor qa -t lib/flavors/qa/main_qa.dart
- flutter run --flavor staging -t lib/flavors/staging/main_staging.dart
- flutter run --flavor prod -t lib/flavors/prod/main_prod.dart

### Notes Mandatory

- It is must to use vscode to follow lint rules defined in analysis_options.yml
- Avoid using try catch in all layers except infrastructure layer
- Override local vscode settings with project vscode settings so everyone follows same standards
- Follow the existing file name conventions and project structure
- Dto's should be included within infrastructure layer and every Dto should have an entitiy with .empty method defined in domain layer
- All of the app's business logic should be handled in application layer with blocs
- Keep function specific things within function body and dont create un-necessary files to make them be used globally
- Keep widgets in single file if they are not shared between other components
- If a component is to be shared among others, define it with core folder in that specific layer
- Every module should have a route defined in routes.dart
