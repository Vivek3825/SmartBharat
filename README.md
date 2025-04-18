# SmartBharat

# 🚜 SmartBharat: AI-Powered Rural Assistant

SmartBharat is a voice-based mobile app built for rural India. It provides updates on government schemes, healthcare, weather, and more — in local languages, with an easy-to-use interface.

---

## 📌 Current Progress

- ✅ Home page UI with key feature buttons
- ✅ Multi-language support (Hindi, English, Marathi, Tamil, Telugu)
- ✅ Language selector using `Provider` + `shared_preferences`
- ✅ LocalizedText widget for dynamic UI updates
- ✅ Responsive layout that adapts to different languages and screen sizes
- ✅ Tamil-specific text adjustments and font scaling
- ✅ Auto-rotating alert banners with icons and animations
- ✅ Profile page with:
  - Avatar and editable fields
  - Government schemes tracking
  - Security, feedback, and logout section
- ✅ UI polish with borders, shadows, ellipsis protection, and maxLines


## 📁 Key Flutter Files

- `home.dart` – Main UI with feature buttons and quick actions
- `profile.dart` – User profile with scheme tracking and settings
- `language_provider.dart` – App-wide language state manager
- `translation.dart` – Centralized string translations
- `localized_text.dart` – Widget to show translated text dynamically


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
