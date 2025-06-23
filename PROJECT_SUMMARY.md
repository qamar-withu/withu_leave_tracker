# Withu Leave Tracker - Project Summary

## 🎯 Project Overview

This is a comprehensive leave tracker application built using Flutter with Domain-Driven Design (DDD) architecture. The app is designed for companies to manage employee leave requests, team assignments, and project-based team separation.

## 🏗️ Architecture

The project follows strict DDD principles with 4 layers:

### 1. **Presentation Layer** (`lib/presentation/`)
- UI components and pages
- BLoC state management integration
- Modern, responsive design
- Supports iOS, Android, and Web

### 2. **Application Layer** (`lib/application/`)
- Business logic using BLoC pattern
- Event handling and state management
- Coordinates between presentation and domain layers

### 3. **Domain Layer** (`lib/domain/`)
- Core business entities
- Repository interfaces (facades)
- Value objects and validation logic
- Business rules and failures

### 4. **Infrastructure Layer** (`lib/infrastructure/`)
- Firebase integration (Auth, Firestore)
- Data transfer objects (DTOs)
- Repository implementations
- External service communication

## 🚀 Key Features

### ✅ Implemented
- **Authentication System**: Firebase Auth integration with login/register flows
- **Team Management**: Project-based team separation with comprehensive management
- **Leave Request System**: Full CRUD operations for leave requests
- **Team Calendar**: Interactive calendar with leave request visualization
- **Daily Leave Details**: Detailed view of users on leave for specific dates
- **Dashboard**: Comprehensive overview with statistics and quick actions
- **Profile Management**: User profile with settings and preferences
- **Modern Navigation**: Bottom navigation with consistent user experience
- **Modern UI**: Material Design 3 with custom theme and gradients
- **Multi-Platform**: iOS, Android, and Web support
- **Type Safety**: Freezed for immutable data classes
- **Code Generation**: Automatic code generation for serialization
- **Dependency Injection**: Injectable for clean dependency management
- **Username Support**: Display actual user names instead of user IDs
- **Modern Flutter Syntax**: Updated to use `.withValues()` instead of deprecated `.withOpacity()`

### 🔄 Core Entities
1. **User**: Employee information with role-based access
2. **Project**: Project management with teams
3. **Team**: Team organization within projects
4. **Leave Request**: Comprehensive leave management

### 🎨 UI Components
- Custom text fields with validation
- Modern buttons with loading states
- Responsive layout with ScreenUtil
- Beautiful gradient backgrounds
- Custom color scheme

## 📁 Project Structure

```
lib/
├── main.dart                           # Main entry point
├── config.dart                         # App configuration
├── routes.dart                         # Navigation setup
├── locator.dart                        # Dependency injection
├── core/
│   ├── constants/                      # App constants and colors
│   ├── extensions/                     # Dart extensions
│   ├── utils/                          # Utility functions
│   └── widgets/                        # Shared widgets
├── presentation/
│   ├── core/
│   │   ├── theme/                      # App theme configuration
│   │   └── widgets/                    # Reusable UI components
│   ├── auth/                           # Authentication pages (login, register)
│   ├── dashboard/                      # Dashboard with statistics and overview
│   ├── leave_request/                  # Leave request management (create, view, manage)
│   ├── team_calendar/                  # Team calendar with daily details view
│   ├── team_management/                # Team and project management
│   └── profile/                        # User profile and settings
├── application/
│   ├── auth/                           # Authentication BLoC
│   ├── dashboard/                      # Dashboard BLoC
│   ├── leave_request/                  # Leave request BLoC
│   ├── team_management/                # Team management BLoC
│   └── profile/                        # Profile BLoC
├── domain/
│   ├── core/
│   │   ├── errors/                     # Failure definitions
│   │   └── value_objects/              # Common value objects
│   ├── auth/
│   │   ├── entities/                   # User entity
│   │   └── repository/                 # Auth repository interface
│   ├── leave_request/
│   │   ├── entities/                   # Leave request entity
│   │   └── repository/                 # Leave request repository interface
│   └── team_management/
│       ├── entities/                   # Project and Team entities
│       └── repository/                 # Team management repository interface
├── infrastructure/
│   ├── auth/
│   │   ├── dto/                        # User DTOs
│   │   ├── datasource/                 # Firebase Auth datasource
│   │   └── repository/                 # Auth repository implementation
│   ├── leave_request/
│   │   ├── dto/                        # Leave request DTOs
│   │   ├── datasource/                 # Firestore datasource
│   │   └── repository/                 # Leave request repository implementation
│   └── team_management/
│       ├── dto/                        # Project and Team DTOs
│       ├── datasource/                 # Firestore datasource
│       └── repository/                 # Team management repository implementation
└── flavors/                            # Environment-specific configurations
    ├── dev/
    ├── qa/
    ├── staging/
    └── prod/
```

## 🛠️ Technologies Used

- **Flutter 3.8+**: Modern UI framework with latest features
- **Firebase**: Authentication and Firestore database
- **BLoC**: State management with flutter_bloc
- **Freezed**: Immutable data classes and union types
- **Injectable**: Dependency injection with get_it
- **Go Router**: Declarative routing with type safety
- **Table Calendar**: Interactive calendar widget
- **Flutter ScreenUtil**: Responsive design utilities
- **Dartz**: Functional programming for error handling
- **Build Runner**: Code generation tooling
- **JSON Annotation**: Serialization support

## 🔧 Setup Instructions

### Prerequisites
1. Flutter SDK 3.8+
2. Firebase project setup
3. Valid development environment (Xcode for iOS, Android Studio for Android)

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Configure Firebase:
   - Update `lib/config.dart` with your Firebase configuration
   - Add Firebase configuration files for each platform

### Running the App

#### Development
```bash
flutter run --flavor dev -t lib/flavors/dev/main_dev.dart
```

#### Different Platforms
```bash
# iOS
flutter run --flavor dev -t lib/flavors/dev/main_dev.dart -d ios

# Android
flutter run --flavor dev -t lib/flavors/dev/main_dev.dart -d android

# Web
flutter run --flavor dev -t lib/flavors/dev/main_dev.dart -d web

# macOS (requires deployment target update)
flutter run --flavor dev -t lib/flavors/dev/main_dev.dart -d macos
```

## 🔍 Current Status

### ✅ Completed
- **Project Architecture**: Complete DDD structure with 4-layer architecture
- **Domain Layer**: All core entities, value objects, and repository interfaces
- **Infrastructure Layer**: Firebase integration with Auth and Firestore
- **Authentication System**: Complete login/register flow with validation
- **Dashboard Implementation**: 
  - Overview with leave statistics and team information
  - Modern hero section with user greeting
  - Quick action buttons for common tasks
  - Recent leave requests display
- **Leave Request Management**:
  - Complete CRUD operations (Create, Read, Update, Delete)
  - Form validation and error handling
  - Status management (pending, approved, rejected)
  - Date range selection and validation
- **Team Calendar**:
  - Interactive calendar with TableCalendar integration
  - Leave request visualization with event markers
  - Daily details view showing users on leave
  - Navigation between calendar and detail views
- **Navigation System**:
  - Bottom navigation bar across all main pages
  - Consistent navigation experience
  - Proper route management with GoRouter
- **UI/UX Enhancements**:
  - Modern Material Design 3 theme
  - Custom color schemes and gradients
  - Responsive design with ScreenUtil
  - Loading states and error handling
  - Form validation with user feedback
- **Code Quality**:
  - Updated to modern Flutter syntax (`.withValues()` vs deprecated `.withOpacity()`)
  - Type-safe code with Freezed data classes
  - Proper dependency injection setup
  - Code generation for serialization
- **Username Integration**:
  - Added userName field to domain models
  - Updated DTOs to include username mapping
  - Display actual names instead of user IDs in UI

### 🚧 In Progress / Next Steps
1. **Enhanced Team Management**
   - Advanced team creation and editing workflows
   - Project assignment and member management
   - Role-based permissions and access control

2. **Advanced Leave Management**
   - Leave approval workflow with manager notifications
   - Leave balance tracking and calculations
   - Recurring leave patterns and templates

3. **Reporting and Analytics**
   - Team leave statistics and reports
   - Leave trend analysis
   - Export functionality for reports

4. **Admin Features**
   - System-wide configuration settings
   - User role and permission management
   - Audit logs and system monitoring

5. **Performance Optimizations**
   - Data caching strategies
   - Offline support capabilities
   - Performance monitoring and optimization

6. **Testing and Quality Assurance**
   - Unit tests for business logic
   - Widget tests for UI components
   - Integration tests for user workflows

## 🐛 Known Issues

1. **Minor Deprecation Warnings**: Some core widget components still use deprecated `.withOpacity()` method. Main application pages have been updated to use modern `.withValues()` syntax.
2. **Firebase Configuration**: Requires proper Firebase project setup and configuration files for deployment.
3. **macOS Deployment**: Requires updating deployment target to 10.15+ for macOS builds.
4. **Unused Imports**: Some files have unused import statements that can be cleaned up.

## 📱 Application Features

### Core User Flows
1. **Authentication Flow**
   - User registration with email/password
   - Secure login with form validation
   - Password visibility toggle and requirements

2. **Dashboard Experience**
   - Personalized greeting with user name
   - Leave statistics overview (total, used, remaining)
   - Quick actions for common tasks
   - Recent leave requests with status indicators

3. **Leave Management**
   - Create new leave requests with date picker
   - Select leave type (Annual, Sick, Casual, etc.)
   - Add reason and optional comments
   - View all personal leave requests with filtering
   - Delete pending requests

4. **Team Calendar**
   - Monthly calendar view with leave indicators
   - Select specific dates to view details
   - Navigate to daily view showing all users on leave
   - Color-coded status indicators

5. **Profile Management**
   - View and edit personal information
   - Update profile settings
   - Manage account preferences

### Technical Features
- **Real-time Updates**: Firebase integration for live data
- **Responsive Design**: Works across mobile, tablet, and web
- **Type Safety**: Comprehensive type checking with Dart
- **State Management**: BLoC pattern for predictable state updates
- **Navigation**: Consistent bottom navigation across all screens
- **Error Handling**: User-friendly error messages and validation
- **Loading States**: Progress indicators for better UX

## 🔄 Build Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs

# Run code generation only
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development
dart run build_runner watch --delete-conflicting-outputs
```

## 📋 Development Guidelines

1. **File Organization**: Follow the established folder structure
2. **Naming Conventions**: Use existing naming patterns
3. **State Management**: Use BLoC pattern consistently
4. **Data Flow**: Respect the DDD layer boundaries
5. **Code Generation**: Use Freezed for data classes
6. **Testing**: Maintain test coverage for business logic

## 🎯 Business Logic

The app implements a comprehensive leave management system where:
- **Users**: Employees with role-based access (Employee, Manager, Admin)
- **Teams**: Organized groups within projects with designated managers
- **Projects**: Top-level organizational units containing multiple teams
- **Leave Requests**: Complete lifecycle from creation to approval/rejection
- **Calendar Integration**: Visual representation of team availability
- **Approval Workflow**: Manager approval required for leave requests
- **Status Tracking**: Real-time status updates (Pending, Approved, Rejected)
- **User Experience**: Intuitive navigation with bottom navigation bar
- **Data Persistence**: Firebase Firestore for reliable data storage

### Key Business Rules
1. Employees can only view and manage their own leave requests
2. Managers can approve/reject requests for their team members
3. Leave requests require start date, end date, type, and reason
4. Users can delete only pending leave requests
5. Calendar shows team-wide leave visibility
6. Real-time updates across all connected devices

This architecture ensures scalability, maintainability, and provides a clean separation of concerns while delivering an excellent user experience.

## 📊 Implementation Status

### Fully Implemented Pages
- ✅ **Authentication Pages**: Login and Registration with validation
- ✅ **Dashboard Page**: Statistics, quick actions, and recent requests
- ✅ **Leave Requests Page**: View all personal leave requests with CRUD operations
- ✅ **Create Leave Request Page**: Form-based leave creation with validation
- ✅ **Team Calendar Page**: Interactive calendar with leave visualization
- ✅ **Daily Calendar Detail Page**: Detailed view of users on leave per day
- ✅ **Profile Page**: User profile management and settings

### Navigation & UX
- ✅ **Bottom Navigation**: Consistent navigation across all main pages
- ✅ **Route Management**: GoRouter implementation with proper parameter passing
- ✅ **Loading States**: Progress indicators and loading feedback
- ✅ **Error Handling**: User-friendly error messages and validation
- ✅ **Form Validation**: Comprehensive input validation across all forms

### Data Layer
- ✅ **Domain Models**: Complete entities with username support
- ✅ **DTOs**: Firebase integration with proper serialization
- ✅ **Repository Pattern**: Clean separation between data and business logic
- ✅ **State Management**: BLoC implementation across all features

### Code Quality
- ✅ **Modern Syntax**: Updated to latest Flutter recommendations
- ✅ **Type Safety**: Freezed data classes throughout
- ✅ **Code Generation**: Automated serialization and dependency injection
- ✅ **Architecture**: Clean DDD implementation with proper layer separation
