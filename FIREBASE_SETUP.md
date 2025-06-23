# Withu Leave Tracker - Setup Guide

## Firebase Setup and Data Creation Guide

This guide will help you set up Firebase backend and create initial data for the Withu Leave Tracker application.

## Prerequisites

- Flutter SDK (latest stable version)
- Firebase CLI
- A Firebase project
- The Withu Leave Tracker app running locally

## Firebase Configuration

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "withu-leave-tracker"
3. Enable Authentication and Firestore Database

### 2. Configure Authentication

1. In Firebase Console, go to Authentication > Sign-in method
2. Enable Email/Password authentication
3. Optionally enable other providers (Google, Apple, etc.)

### 3. Configure Firestore Database

1. Go to Firestore Database in Firebase Console
2. Create database in production mode
3. Deploy the security rules included in this project:

```bash
firebase deploy --only firestore:rules
```

### 4. Update App Configuration

Replace the Firebase configuration in `lib/main.dart` with your project's configuration from Firebase Console.

## Creating Data Through the App

Once your Firebase is configured and the app is running, follow these steps to create initial data:

### Step 1: User Registration and Setup

1. **Register as Admin User**:
   - Open the app in your browser
   - Click "Sign Up" to create a new account
   - Use email: `admin@company.com` (or your preferred admin email)
   - Create a strong password

2. **Set Up Admin Profile**:
   - After registration, go to Profile page
   - Update profile information:
     - First Name: Admin
     - Last Name: User
     - Phone: Your phone number
     - Role: admin (important for permissions)
     - Department: Management

### Step 2: Create Projects

1. Navigate to Team Management page
2. Click "Create Project"
3. Create your first project:
   - Name: "Mobile App Development"
   - Description: "Customer-facing mobile application"
   - Start Date: Current date
   - Status: "active"
   - Manager: Select your admin user
   - Technologies: ["Flutter", "Firebase"]
   - Client: "Internal Project"

4. Create additional projects as needed:
   - "Web Platform"
   - "Backend Services"
   - "QA Testing"

### Step 3: Create Teams

1. In Team Management, click "Create Team"
2. Create teams for each project:

   **Development Team**:
   - Name: "Frontend Development"
   - Description: "Mobile and web development team"
   - Project: Select "Mobile App Development"
   - Manager: Your admin user
   - Max Members: 8

   **QA Team**:
   - Name: "Quality Assurance"
   - Description: "Testing and quality control team"
   - Project: Select appropriate project
   - Manager: Your admin user
   - Max Members: 5

### Step 4: Create Additional Users

1. Register additional users with different roles:

   **Manager User**:
   - Email: `manager@company.com`
   - Role: manager
   - Department: Engineering
   - Assign to a team

   **Employee Users**:
   - Email: `employee1@company.com`
   - Role: employee
   - Department: Engineering
   - Assign to teams

2. For each new user:
   - Register through the app
   - Update profile with appropriate role
   - Admin can assign users to teams

### Step 5: Create Leave Requests

1. **As Employee Users**:
   - Go to Leave Requests page
   - Click "Create Leave Request"
   - Fill in details:
     - Type: Vacation, Sick, Personal, etc.
     - Start Date and End Date
     - Reason: Brief description
   - Submit for approval

2. **As Manager/Admin**:
   - Review pending requests in dashboard
   - Approve or reject requests
   - Add comments when reviewing

### Step 6: Verify Data Flow

1. **Dashboard Verification**:
   - Check that dashboard shows correct statistics
   - Verify recent requests appear
   - Confirm team pending requests (for managers)

2. **Real-time Updates**:
   - Open app in multiple browser tabs
   - Create a leave request in one tab
   - Verify it appears in dashboard of another tab
   - Test approval/rejection flow

## Sample Data Structure

After following the steps above, your Firestore should contain:

### Users Collection
- Admin user with role: "admin"
- Manager user with role: "manager"  
- Employee users with role: "employee"
- Each with complete profile information

### Projects Collection
- Mobile App Development project
- Web Platform project
- Backend Services project
- Each with manager assignments and details

### Teams Collection
- Frontend Development team
- QA team
- Backend team
- Each linked to projects with member assignments

### Leave Requests Collection
- Various leave requests from employees
- Different statuses: pending, approved, rejected
- Proper date ranges and reasons

## Testing the Application

### 1. Employee Flow
- Login as employee
- View personal dashboard
- Create leave requests
- Check leave balance
- Update profile

### 2. Manager Flow
- Login as manager
- View team dashboard
- Review team leave requests
- Approve/reject requests
- Manage team members

### 3. Admin Flow
- Login as admin
- View organization dashboard
- Manage all teams and projects
- Handle escalated requests
- Manage user roles

## Firestore Security Rules

The included security rules ensure:
- Users can only access their own data
- Managers can access their team's data
- Admins have broader access
- All operations require authentication

## Troubleshooting

### Common Issues

1. **Authentication Errors**:
   - Verify Firebase Auth is enabled
   - Check API keys in configuration
   - Ensure email/password provider is enabled

2. **Firestore Permission Errors**:
   - Deploy security rules: `firebase deploy --only firestore:rules`
   - Verify user roles are set correctly
   - Check document ownership in Firestore Console

3. **Data Not Appearing**:
   - Check Firestore indexes are created
   - Verify collection names match the code
   - Check browser console for errors

4. **Real-time Updates Not Working**:
   - Verify Firestore real-time listeners are active
   - Check network connectivity
   - Refresh the application

### Getting Help

- Check the main README.md for architecture details
- Review Firebase Console for data structure
- Check browser developer tools for errors
- Verify all Firebase services are enabled

## Next Steps

Once you have initial data:
1. Test all user flows thoroughly
2. Create additional sample data as needed
3. Configure any additional Firebase features
4. Set up production deployment
5. Configure monitoring and analytics

This setup provides a solid foundation for the Withu Leave Tracker application with real Firebase data integration.
