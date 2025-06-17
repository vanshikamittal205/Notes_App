# note_ily

A note-taking application built with Flutter and Firebase, supporting e-mail and google authentication options, real-time syncing and CRUD operations.

## ✨ Features 
 Firebase Authentication – Secure login system for each user.  <br>
 Firestore Integration – Notes are stored in Firestore with real-time updates.<br>
 Create, Read, Update, Delete (CRUD) – Fully functional note editor. <br>
 Mark as Completed – Make a To-Do List and track pending and completed task with percentage of pending tasks displayed dynamically. <br>
 Responsive UI – Clean dark-themed interface for better readability. <br>
 Timestamps – Notes display last updated time. <br>

## Getting Started

## Prerequisites
Flutter SDK (3.0 or later recommended) <br>
Firebase project setup <br>
Android/iOS emulator or physical device <br>

## Firebase Setup
Create a Firebase project at console.firebase.google.com. <br>
Add your Android/iOS app to Firebase. <br>
Enable Authentication → Email/Password. <br>
Enable Cloud Firestore in test mode (for development). <br>
Download and add your google-services.json (Android) or GoogleService-Info.plist (iOS). <br>
Add Firebase packages in pubspec.yaml: <br>

## dependencies:
  firebase_core: ^latest <br>
  firebase_auth: ^latest <br>
  cloud_firestore: ^latest <br>

## Usage
Run flutter pub get 

Run the app: <br>
flutter run

Sign in with a user account. <br>
Start creating notes, editing, deleting, or starring them!

## Improvements

 Add search and filter for notes <br>
 Add Favourite Note Options <br>
 Offline support <br>
 Note color labels or categories <br>
 Rich text support (bold, lists, etc.) <br>
 Add an option to set deadline <br>
 Notifications of tasks due in.. <br>
 Edit profile feature <br>



## Here is an demo video of the app:
https://github.com/user-attachments/assets/51623ca6-ec68-44c9-a5be-28ed118ce56f


