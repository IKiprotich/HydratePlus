# 💧 Hydrate+

Hydrate+ is a SwiftUI-based hydration tracking app designed to help users stay consistent with their daily water intake. With streak tracking, motivational reminders, progress stats, and a beautiful, fluid interface, Hydrate+ makes staying healthy effortless and engaging.

---

## 🚀 Features

- ✅ Log daily water intake
- 🔁 Streak system that rewards consistency
- 📈 Track stats like daily average and total intake
- 📆 Persistent hydration history
- 🧑 Personalized dashboard with greetings
- 🌙 Clean, responsive, dark-mode-friendly UI
- 🔐 User authentication and profile management
- 📲 Onboarding flow to introduce new users to the app

---

## 🛠 Built With

This project is built entirely with **SwiftUI** and **Firebase**, showcasing a modern and scalable iOS architecture.

---

## 📚 SwiftUI Concepts I Used & Learned

### ✅ State Management
- `@State`, `@Binding`, `@ObservedObject`, and `@EnvironmentObject` were used throughout the app for managing state between views.
- Learned how to structure view models to follow the **MVVM architecture** without overcomplicating the code.

### ✅ Navigation & View Composition
- `NavigationStack` and `NavigationLink` used to create a fluid and intuitive navigation system.
- Modularized views like `WaterLogItem`, `StreakCard`, and `StatsCard` helped maintain code clarity and reusability.

### ✅ Layout and Design
- Mastered **Stacks (VStack, HStack, ZStack)** for layout and responsive design.
- Used `GeometryReader` for dynamic sizing and adaptive UI.
- Learned to build consistent UI with reusable **custom components** and theming.

### ✅ Animations & Transitions
- Integrated subtle `withAnimation` and `.transition()` effects for log-ins, tab switches, and card displays to make the app feel alive.

### ✅ Firebase Integration
- Set up **Firebase Authentication** for account creation and login.
- Used **Firestore** to persist user logs, streaks, profile data, and goals.
- Integrated **Firestore's real-time updates** to reflect hydration data immediately across views.

### ✅ Scheduling & Background Tasks
- Implemented **local notifications** using `UNUserNotificationCenter` with custom motivational messages.
- Learned how to schedule repeated notifications conditionally (e.g., only when a goal hasn’t been reached).

### ✅ App Architecture
- Refactored the app to follow **MVVM**:
  - View files for UI logic
  - ViewModel files for state and Firebase interaction
  - Model structs for data structure (e.g., `WaterLog`, `UserProfile`)
- Used comments and file organization to maintain clarity and scalability.

### ✅ Error Handling & UX Feedback
- Added friendly UI alerts and error messages.
- Learned to debug layout issues (e.g. conflicting constraints, invalid numeric values) and optimize input forms.

---

## 📸 Screenshots
![Simulator Screenshot - iPhone11 - 2025-05-21 at 09 49 15](https://github.com/user-attachments/assets/89c7dcb1-e3d2-4f77-a1da-4e0b406b502e)
![Simulator Screenshot - iPhone11 - 2025-05-21 at 09 48 53](https://github.com/user-attachments/assets/3e7d5fb6-0ea0-44b0-b71a-328bdcce34fe)
![Simulator Screenshot - iPhone11 - 2025-05-21 at 09 48 41](https://github.com/user-attachments/assets/da261ce7-e32b-42bc-8f23-7503e4f7092a)
![Simulator Screenshot - iPhone11 - 2025-05-21 at 09 48 32](https://github.com/user-attachments/assets/b18ddb85-12e3-46a4-87b0-6e4c0f31f4c0)
![Simulator Screenshot - iPhone11 - 2025-05-21 at 09 48 22](https://github.com/user-attachments/assets/8bf1b473-3ca3-472e-81df-3490aef6f267)
![Simulator Screenshot - iPhone11 - 2025-05-21 at 09 47 51](https://github.com/user-attachments/assets/e6cc7a5b-6e89-4f6d-ac19-9c9072ed590d)
![Simulator Screenshot - iPhone11 - 2025-05-21 at 09 45 31](https://github.com/user-attachments/assets/c45a812d-ed4b-4156-85bf-2938e5ee458a)
![Simulator Screenshot - iPhone11 - 2025-05-21 at 09 45 17](https://github.com/user-attachments/assets/51f9de97-bf96-4748-be6c-bc4a6d7aa7bb)


## 🧠 Lessons & Takeaways
This project helped me:

   - Deepen my understanding of SwiftUI and declarative UI building

   - Learn the MVVM pattern in a real-world project

   - Set up and use Firebase in Swift

   - Handle scheduling and system-level notifications

   - Debug challenging UI and layout issues

   - Improve app structure, navigation, and scalability


## 🧑‍💻 Author
Made with ❤️ by Ian


