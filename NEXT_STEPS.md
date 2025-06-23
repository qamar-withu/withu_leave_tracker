# 🚀 Withu Leave Tracker - Next Steps Guide

## Immediate Fixes Required

### 1. **Web Compilation Issue** (Priority: HIGH)
The web compilation is failing because the main function isn't being recognized. To fix:

```bash
# Option 1: Try running without custom target
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000

# Option 2: Clean and rebuild web-specific files
flutter clean
flutter pub get
flutter build web --debug
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000
```

### 2. **Firebase Configuration** (Priority: HIGH)
Update the Firebase configuration in `lib/config.dart`:

```dart
static const Map<String, FirebaseConfig> firebaseConfigs = {
  'dev': FirebaseConfig(
    projectId: 'your-actual-firebase-project-id',
    apiKey: 'your-actual-api-key',
    appId: 'your-actual-app-id',
  ),
  // ... other environments
};
```

Add Firebase configuration files:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `web/firebase-config.js`

### 3. **macOS Deployment Target** (Priority: MEDIUM)
Update `macos/Runner.xcodeproj` deployment target to 10.15+ in Xcode.

## Implementation Roadmap

### Phase 1: Core Authentication (Week 1)
- [ ] Complete registration page
- [ ] Implement password reset
- [ ] Add form validation
- [ ] Test authentication flow

### Phase 2: Dashboard & Navigation (Week 2)
- [ ] Implement dashboard with statistics
- [ ] Add bottom navigation
- [ ] Create leave request summary cards
- [ ] Add quick action buttons

### Phase 3: Leave Request Management (Week 3)
- [ ] Create leave request form with date picker
- [ ] Implement request submission
- [ ] Add request status tracking
- [ ] Create approval workflow for managers

### Phase 4: Team Management (Week 4)
- [ ] Implement team creation
- [ ] Add project management
- [ ] Create member assignment
- [ ] Add role-based permissions

### Phase 5: Advanced Features (Week 5+)
- [ ] Calendar integration
- [ ] Push notifications
- [ ] Email notifications
- [ ] Reporting and analytics
- [ ] Export functionality

## Detailed Implementation Steps

### 1. **Complete Registration Page**

```dart
// Add to lib/presentation/auth/register_page.dart
class RegisterPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            CustomTextField(label: 'First Name'),
            CustomTextField(label: 'Last Name'),
            CustomTextField(label: 'Email'),
            CustomTextField(label: 'Password', isPassword: true),
            // Team/Project selection dropdowns
            CustomButton(text: 'Register'),
          ],
        ),
      ),
    );
  }
}
```

### 2. **Implement Dashboard**

```dart
// Create lib/presentation/dashboard/dashboard_page.dart
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(
        children: [
          // Stats cards
          Row(
            children: [
              StatCard(title: 'Pending', count: 5),
              StatCard(title: 'Approved', count: 12),
              StatCard(title: 'Remaining', count: 15),
            ],
          ),
          // Recent requests
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => LeaveRequestCard(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/leave-requests/create'),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 3. **Create Leave Request Form**

```dart
// Create lib/presentation/leave_request/create_leave_request_page.dart
class CreateLeaveRequestPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request Leave')),
      body: Form(
        child: Column(
          children: [
            DropdownButtonFormField(
              items: AppConstants.leaveTypes,
              decoration: InputDecoration(labelText: 'Leave Type'),
            ),
            // Date pickers for start/end dates
            CustomTextField(
              label: 'Reason',
              maxLines: 3,
            ),
            SwitchListTile(
              title: Text('Half Day'),
              value: isHalfDay,
            ),
            CustomButton(
              text: 'Submit Request',
              onPressed: () => _submitRequest(),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Firebase Setup Guide

### 1. **Create Firebase Project**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project
3. Enable Authentication (Email/Password)
4. Create Firestore Database

### 2. **Firestore Structure**
```
users/
  {userId}/
    firstName: string
    lastName: string
    email: string
    role: string
    teamId: string
    projectId: string
    createdAt: timestamp

projects/
  {projectId}/
    name: string
    description: string
    managerId: string
    isActive: boolean

teams/
  {teamId}/
    name: string
    projectId: string
    managerId: string
    memberIds: array

leave_requests/
  {requestId}/
    userId: string
    leaveType: string
    startDate: timestamp
    endDate: timestamp
    status: string
    reason: string
    approvedBy: string (optional)
```

### 3. **Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Leave requests
    match /leave_requests/{requestId} {
      allow read, write: if request.auth != null;
    }
    
    // Projects and teams (read-only for employees)
    match /projects/{projectId} {
      allow read: if request.auth != null;
    }
    
    match /teams/{teamId} {
      allow read: if request.auth != null;
    }
  }
}
```

## Testing Strategy

### 1. **Unit Tests**
- Domain entities validation
- Repository implementations
- BLoC state management

### 2. **Integration Tests**
- Firebase authentication flow
- Firestore data operations
- Navigation flows

### 3. **Widget Tests**
- UI component rendering
- Form validation
- User interactions

## Deployment Strategy

### 1. **Web Deployment**
```bash
flutter build web --release
# Deploy to Firebase Hosting, Netlify, or similar
```

### 2. **Mobile Deployment**
```bash
# Android
flutter build apk --release --flavor prod -t lib/flavors/prod/main_prod.dart

# iOS
flutter build ios --release --flavor prod -t lib/flavors/prod/main_prod.dart
```

### 3. **Environment Management**
Use flavors for different environments:
- Dev: Development testing
- QA: Quality assurance
- Staging: Pre-production testing
- Prod: Production release

## Performance Optimization

1. **Lazy Loading**: Implement pagination for large datasets
2. **Caching**: Cache frequently accessed data
3. **Image Optimization**: Optimize profile images
4. **Bundle Size**: Analyze and reduce app size
5. **Database Queries**: Optimize Firestore queries

## Security Considerations

1. **Input Validation**: Validate all user inputs
2. **Access Control**: Implement role-based permissions
3. **Data Encryption**: Encrypt sensitive data
4. **API Security**: Secure Firebase rules
5. **Authentication**: Implement proper session management

This roadmap provides a clear path to complete the leave tracker application with modern best practices and scalable architecture.
