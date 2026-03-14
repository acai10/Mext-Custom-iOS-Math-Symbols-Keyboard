# 🧮 Mext – Custom iOS Math Symbols Keyboard

Mext is an iOS keyboard extension built in Swift that allows users to type math symbols easily.  
It supports dynamic key colors, iOS-like key animations, and a mini-game mechanic for playful interaction while typing.

---

## ✨ Features

- 🎨 **Dynamic key colors** – Customize individual key colors or entire themes  
- ✨ **iOS-like key animations** – Smooth and natural key tap animations  
- 🧮 **Math symbol support** – Quickly type common mathematical symbols  
- 🕹️ **Mini-game mechanic** – Keys can trigger a "clicker"-style system with counters and probabilities  
- 🛠️ **Helper functions** – Utilities for text input, layout adjustments, and internal keyboard logic  
- 📦 **Swift + UIKit** – Fully written in Swift, compatible with modern iOS versions  

---

## 🛠 Tech Stack

| Component | Technology |
| :--- | :--- |
| **Language** | Swift |
| **Development** | iOS SDK (Xcode) |
| **Architecture** | Modular / UIKit-based |
| **Testing** | Xcode Unit & UI Tests |

---

## 🏗 Project Overview

The keyboard extension separates UI, logic, and helper functions for maintainability:

- 🎛️ **KeyboardViewController** – Handles layout, taps, animations, and symbol input  
- 🛠️ **HelperFunctions.swift** – Utility functions for text input, counters, and mini-game logic  
- 🖋️ **Symbols.swift** – Defines available math symbols  
- 🎨 **Assets.xcassets** – Key colors, icons, and themes  

This modular design ensures easy feature extensions, testing, and maintainability.

---

## 📂 Project Structure

```
├── 📁 Mext
│   ├── 📁 Assets.xcassets
│   │   ├── 📁 AccentColor.colorset
│   │   │   └── ⚙️ Contents.json
│   │   ├── 📁 AppIcon.appiconset
│   │   │   ├── ⚙️ Contents.json
│   │   │   ├── 🖼️ mext_icon_any.png
│   │   │   └── 🖼️ mext_icon_dark.png
│   │   └── ⚙️ Contents.json
│   ├── 🍎 ContentView.swift
│   ├── 📄 Mext.entitlements
│   └── 🍎 MextApp.swift
├── 📁 Mext.xcodeproj
│   ├── 📁 project.xcworkspace
│   │   ├── 📁 xcshareddata
│   │   │   └── 📁 swiftpm
│   │   │       └── 📁 configuration
│   │   └── 📄 contents.xcworkspacedata
│   ├── 📁 xcshareddata
│   │   └── 📁 xcschemes
│   │       ├── 📄 Mext.xcscheme
│   │       └── 📄 keyboard ext.xcscheme
│   └── 📄 project.pbxproj
├── 📁 MextTests
│   └── 🍎 MextTests.swift
├── 📁 MextUITests
│   ├── 🍎 MextUITests.swift
│   └── 🍎 MextUITestsLaunchTests.swift
├── 📁 keyboard ext
│   ├── 🍎 HelperFunctions.swift
│   ├── 📄 Info.plist
│   ├── 🍎 KeyboardViewController.swift
│   ├── 🍎 Symbols.swift
│   └── 📄 keyboard ext.entitlements
├── ⚙️ .gitignore
└── 📝 README.md
```

---

## 🚀 Running the Project

### Requirements
- macOS & Xcode
- iOS Simulator or physical iPhone

### Steps
1. **Clone the repository:**
   ```bash
   git clone git@github.com:acai10/Mext-Custom-iOS-Math-Symbols-Keyboard.git
   ```
2. **Open in Xcode:** Open `Mext.xcodeproj`  
3. **Replace bundle identifiers and App Group IDs** *(see section below)*  
4. **Build & Run:** Select a simulator or device and press `Cmd + R`  
5. **Enable the keyboard in iOS settings:**  
   **Settings → General → Keyboard → Add New Keyboard → Mext**

---

## 🔧 Configuration – Bundle Identifiers & App Groups

Before building, replace all occurrences of the placeholder identifiers with your own values.

### App Group ID

The App Group is used to share data between the main app and the keyboard extension. Replace every occurrence of:

```xml
group.com.acai10.mext
```

with your own App Group ID, e.g.:

```xml
group.com.yourname.mext
```

You'll need to update this in the following places:

- `Mext/Mext.entitlements`
- `keyboard ext/keyboard ext.entitlements`
- Any code in `HelperFunctions.swift` or `KeyboardViewController.swift` that references the App Group

### Bundle Identifier

Replace the bundle identifier `com.acai10.mext` with your own in:

- **Xcode project settings** → Select the `Mext` target → *General* → *Bundle Identifier*
- **Xcode project settings** → Select the `keyboard ext` target → *General* → *Bundle Identifier* (typically `com.yourname.mext.keyboard-ext`)
- `keyboard ext/Info.plist`

### App Group Registration (Apple Developer Portal)

Make sure your App Group is registered in the [Apple Developer Portal](https://developer.apple.com/account):

1. Go to **Certificates, Identifiers & Profiles → Identifiers**
2. Create a new **App Group** with your chosen ID (e.g., `group.com.yourname.mext`)
3. Add the App Group to both your **App ID** and your **Keyboard Extension ID**
4. Regenerate and download the corresponding provisioning profiles

> ⚠️ Without matching App Group IDs across the app and extension, data sharing between them will not work.

---

## 🎯 Purpose

This project explores:

- **iOS keyboard extension development** with Swift and UIKit  
- **Custom UI design** with dynamic key colors and animations  
- **Math symbol input** for easy typing of common symbols  
- **Lightweight modular architecture** for maintainable and testable code  

---

## 🔮 Future Improvements

- Customizable keyboard themes  
- Expanded math symbol sets  
- Enhanced mini-game counters and probabilities  
- Haptic feedback support  
- Optional iCloud sync for user settings  

---

## ⚠️ Disclaimer

This project is for educational and experimental purposes only.  
It is **not intended for professional mathematical software**, but as a playful and practical keyboard extension.