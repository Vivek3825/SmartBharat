# SmartBharat

# 🚜 SmartBharat: AI-Powered Rural Assistant

SmartBharat is a voice-based mobile app built for rural India. It provides updates on government schemes, healthcare, weather, and more — in local languages, with an easy-to-use interface.

## 🔐 Firebase Integration

We integrated Firebase to handle user authentication and profile management securely, using Firestore as the backend.

### ✅ Services Used

- **Firebase Authentication**
  - Email/password-based login
  - Password reset via email
  - Persistent login sessions

- **Cloud Firestore**
  - Stores user profile data
  - Enforced user-level data access via security rules

### 🛠️ Files Added/Updated

- `google-services.json` – Firebase config file
- `firebase_auth_service.dart` – Abstracts auth operations
- `UserProvider` – Handles login/register/logout and auth state
- `login.dart`, `register.dart`, `setpass.dart` – Connected to Firebase
- `profile.dart` – Fetches/updates user data from Firestore
- `build.gradle` (Project & App-level) – Added Firebase dependencies

### 🔁 Auth Flow

- **Register:** Creates Firebase user and saves profile to Firestore  
- **Login:** Validates credentials and loads user data  
- **Reset Password:** Sends email with reset instructions  
- **Auto Login:** Maintains session after restart  

### 🔒 Security & State

- Firebase rules ensure only the authenticated user accesses their data
- Full error handling and state updates integrated with `UserProvider`
- UI remains responsive during all operations


## 📦 Firebase Build Setup (Android)

- **Min SDK Version:** 21
- **Target SDK Version:** 35
- **NDK Version:** 27.0.12077973
- **Firebase SDKs:** Auth, Firestore
- Added `google-services.json` to `/android/app/`
- Applied Firebase plugin and dependencies in `build.gradle.kts`


## 👥 Team

- Vivek (AI and App development)
- Saurabh (App development)
- Shubham (UI designer)
- Sanket (Paper work)


## 📂 How to Run

```bash
# Clone the repository
git clone https://github.com/Vivek3825/SmartBharat.git

# Go into the project folder
cd SmartBharat

# Get Flutter dependencies
flutter pub get

# Run the app
flutter run
