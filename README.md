# SmartBharat

# 🚜 SmartBharat: AI-Powered Rural Assistant

SmartBharat is a voice-based mobile app built for rural India. It provides updates on government schemes, healthcare, weather, and more — in local languages, with an easy-to-use interface.

---

## 📌 Current Progress

- ✅ Login Flow Added
  - Created `login.dart`, `register.dart`, `setpass.dart`
  - Redirects to login/register on app launch instead of homepage
  - Clean, minimal UI for login/register
- ✅ Homepage only shown after successful login
- ✅ Tamil language rendering issue fixed (pixel overflow)
- ✅ Glitch & bug fixes for smoother user experience
- ✅ Enhanced navigation smoothness and responsiveness


## 📁 Key Flutter Files

- `main.dart` – Entry point with routing logic
- `login.dart`, `register.dart`, `setpass.dart` – Authentication pages
- `home.dart` – Home screen with sections and quick actions
- `profile.dart` – User profile and scheme tracking
- `language_provider.dart` – State management for language selection
- `translation.dart` – String translations
- `localized_text.dart` – Dynamic text widget for localization



## 🌐 Key Features (In Progress)

- 🔈 Voice-enabled interactions
- 🗣️ Regional language translations
- 📲 Real-time government scheme updates
- 🌦️ Localized weather alerts
- 🏥 Nearby hospital finder
- 🧾 DigiLocker integration (for rural documentation access)
- 📰 Crop prices & news updates


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
