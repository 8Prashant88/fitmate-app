# FitMate – Final Project Report

**Student:** Prashant Sapkota  
**Program:** BIT (VI Semester)  
**Instructor:** Aadarsha Dhakal  
**Date:** August 24, 2025

## Abstract
FitMate is a cross-platform Flutter application that helps users track workouts, meals, and moods with a Firebase backend and Riverpod state management.

## Introduction
The app addresses the challenge of maintaining consistent health routines by providing an intuitive, integrated solution with reminders and progress tracking.


## Technology Stack
Flutter (Dart), Firebase (Auth, Firestore, Messaging), Riverpod, Local Notifications.

## Database Design
Collections: **workouts**, **meals**, **moods** each with a `uid` field tying the document to the authenticated user.

## Implementation
- Authentication via `firebase_auth`
- CRUD via `cloud_firestore`
- Providers & Streams with `flutter_riverpod`
- Notifications via `firebase_messaging` + `flutter_local_notifications`

## Testing & Validation
Manual test cases executed for login, CRUD flows, offline behavior, and notification scheduling. Firebase rules restrict data to document owners.

## Results
App runs on Android/iOS with responsive UI and persistent data.

## Limitations & Future Work
Add analytics dashboard, AI-based meal/workout suggestions, and Google Fit/Apple Health integrations.

## References
Official docs for Flutter, Firebase, and Riverpod.
