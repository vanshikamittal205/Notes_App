# note_ily

A note-taking application built with Flutter and Firebase, supporting e-mail and google authentication options, real-time syncing and CRUD operations.

✨ Features
 Firebase Authentication – Secure login system for each user.
 Firestore Integration – Notes are stored in Firestore with real-time updates.
 Create, Read, Update, Delete (CRUD) – Fully functional note editor.
 Mark as Completed – Make a To-Do List and track pending and completed task with percentage of pending tasks displayed dynamically.
 Responsive UI – Clean dark-themed interface for better readability.
 Timestamps – Notes display last updated time.

## Getting Started

## Prerequisites
Flutter SDK (3.0 or later recommended)
Firebase project setup
Android/iOS emulator or physical device

## Firebase Setup
Create a Firebase project at console.firebase.google.com.
Add your Android/iOS app to Firebase.
Enable Authentication → Email/Password.
Enable Cloud Firestore in test mode (for development).
Download and add your google-services.json (Android) or GoogleService-Info.plist (iOS).
Add Firebase packages in pubspec.yaml:

## dependencies:
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest

## Usage
Run flutter pub get

Run the app:

bash
Copy
Edit
flutter run

Sign in with a user account.
Start creating notes, editing, deleting, or starring them!

## Improvements

 Add search and filter for notes
 Add Favourite Note Options
 Offline support
 Note color labels or categories
 Rich text support (bold, lists, etc.)
 Add an option to set deadline
 Notifications of tasks due in..
 Edit profile feature

https://github.com/user-attachments/assets/604b6929-1608-419f-886a-d899a625399a


