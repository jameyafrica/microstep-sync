# 🧠 MicroStep Sync — Cloud Authentication & Data Ecosystem

> **Cloud-connected authentication, remote synchronization, and user profile management for the MicroStep ADHD productivity ecosystem.**

🎥 **Demo Video:** [Watch the MicroStep Sync Walkthrough on YouTube](#)

---

## 🎯 The Problem
Standard productivity tools assume linear motivation and high cognitive bandwidth. For users with ADHD and executive dysfunction, traditional authentication barriers, rigid onboarding steps, and lack of cloud continuity across devices create friction that leads directly to task abandonment.

## 💡 The Solution: MicroStep Sync
MicroStep Sync is the backend-integrated companion module for the MicroStep ecosystem. It provides low-friction identity management—allowing users to enter immediately via anonymous guest sessions before linking permanent accounts—and securely synchronizes energy levels, micro-task progress, and gentle streak milestones using Firebase services.

---

## ✨ Core Features (Track 2 Scope)
* **Zero-Friction Anonymous Auth:** Instant entry as a guest user to bypass decision paralysis, with seamless linking to permanent email/password accounts later.
* **Email & Password Authentication:** Full user lifecycle handling with secure credential management, password validation, and token persistence.
* **Reactive Auth Guards:** Dynamic view routing utilizing `StreamBuilder` and `authStateChanges()` to automatically manage unauthenticated vs. authenticated states.
* **Cloud Firestore Synchronization:** Secure remote collections syncing user energy logs, gentle streak/pause days, and focus session histories per user UID.
* **Compassionate Error Handling:** Clear, low-anxiety UI feedback designed to gently explain auth and network errors without causing user stress.
* **Automated Test Suite:** Comprehensive Unit, Widget, and Mock tests covering auth services, route guarding, and state transitions.

---

## 🛠️ Tech Stack & Architecture
* **Language:** Dart
* **Framework:** Flutter
* **Cloud Services:** Firebase Authentication, Cloud Firestore
* **CLI & Tooling:** FlutterFire CLI (`firebase_core`, `firebase_auth`, `cloud_firestore`)
* **Testing:** `flutter_test`, `mocktail`, `fake_cloud_firestore`
* **Architecture:** Stream-driven Reactive Architecture isolating Firebase service calls from UI widgets and route guards.

---

## ⚠️ Known Limitations

### No Native Firebase SDK for Linux Desktop
Firebase does not currently publish an official native SDK for Linux desktop.
As a result, `firebase_core`/`firebase_auth`/`cloud_firestore` cannot establish
a live connection when compiled as a native Linux binary (`flutter run -d linux`
will throw a `PlatformException` on `Firebase.initializeApp()`).

**Workaround:** Live/manual Firebase verification during development is done via
`flutter run -d chrome`, using the app's `web` Firebase configuration (registered
alongside `android` via `flutterfire configure`). All automated tests (unit, mock,
and widget) are unaffected by this limitation, since Firebase calls are fully
mocked via `mocktail` / `fake_cloud_firestore` and never touch a real platform
channel or network connection.

The final packaged Linux desktop build targets UI/UX and local behavior; live
cloud sync on that build specifically would require either running the web
build inside a webview, or replacing the official plugins with the
community-maintained `firebase_dart` package (a pure-Dart client that avoids
platform channels entirely). This was evaluated and deferred as out of scope
for the current project phase.

## 🚀 How to Run Locally

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/jameyafrica/microstep-sync.git](https://github.com/jameyafrica/microstep-sync.git)
   cd microstep-sync

Install Flutter dependencies:

Bash
flutter pub get
Configure Firebase:
Ensure you have the FlutterFire CLI installed, then configure your local project environment:

Bash
flutterfire configure
Run the test suite:

Bash
flutter test
Launch the application:

Bash
flutter run -d linux
🎓 About This Project
This project was developed as part of the submission criteria for the Mobile Development elective track selection at WeThinkCode (Cohort 2025).

It fulfills Track 2 (Firebase Authentication with Flutter) requirements, demonstrating competence in cloud infrastructure integration, secure user identity management, reactive stream handling, and automated test coverage.   