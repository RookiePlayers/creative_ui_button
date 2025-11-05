# 🎨 Creative UI Button

A beautifully animated, theme-aware, and highly customizable button library for Flutter.  
It supports multiple variants, async actions, built-in sound and haptic feedback, and smart navigation helpers — all with Material-3-ready design.

---

## ✨ Features

✅ Multiple button variants:
- **Contained**
- **Outlined**
- **Text**
- **Animated**

✅ Built-in animations:
- Pulse  
- Floating  
- Scale-Tap feedback  

✅ Async support:
- `AsyncButton` automatically handles loading states and disables double taps.

✅ Smart navigation:
- `CreativeUIBackButton` pops from the stack, or auto-redirects to a fallback route if the stack is empty.

✅ Theme-aware defaults:
- Automatically adapts to `Theme.of(context).colorScheme` (light or dark).

✅ Plug-and-play customization:
- Gradients, borders, shadows, haptics, SFX, and more.

---

## 🚀 Installation

Add to your project:

```bash
flutter pub add creative_ui_button
```

or manually include in `pubspec.yaml`:

```yaml
dependencies:
  creative_ui_button: ^1.0.0
```

Then import it:

```dart
import 'package:creative_ui_button/creative_ui_button.dart';
```

---

## 🧱 Usage

### 🟦 Contained Button

```dart
CreativeUIButton(
  options: CreativeUIButtonOptions(
    variant: ButtonVariant.contained,
    labelText: 'Play',
    icon: const Icon(Icons.play_arrow, color: Colors.white),
    style: const CreativeUIButtonStyle(
      backgroundColor: Colors.blue,
      borderRadius: 12,
      textStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () => print('Play tapped'),
  ),
);
```

---

### 🟧 Outlined Button

```dart
CreativeUIButton(
  options: CreativeUIButtonOptions(
    variant: ButtonVariant.outlined,
    labelText: 'Cancel',
    style: CreativeUIButtonStyle(
      borderColor: Colors.orange,
      borderWidth: 2,
      textStyle: const TextStyle(color: Colors.orange),
    ),
    onPressed: () => print('Cancelled'),
  ),
);
```

---

### 🔁 Async Button

```dart
AsyncButton(
  options: CreativeUIButtonOptions(
    labelText: 'Submit',
    variant: ButtonVariant.contained,
    style: const CreativeUIButtonStyle(
      backgroundColor: Colors.green,
      textStyle: TextStyle(color: Colors.white),
    ),
  ),
  onAsyncSubmit: () async {
    await Future.delayed(const Duration(seconds: 2));
    print('Submitted');
  },
);
```

The button will show a spinner and disable itself until the async task completes.

---

### ⬅️ Smart Back Button

```dart
CreativeUIBackButton(
  fallbackRoute: '/home', // If stack is empty, navigates to home
  options: CreativeUIButtonOptions(
    variant: ButtonVariant.text,
    style: const CreativeUIButtonStyle(
      textStyle: TextStyle(color: Colors.blue),
    ),
  ),
);
```

---

## ⚙️ Button Variants

| Variant   | Description |
|------------|-------------|
| `contained` | Filled button (default) |
| `outlined`  | Border-only button |
| `text`      | Minimal text-only button |
| `animated`  | Pulse & floating animations with gradient support |

---

## 🪄 Advanced Configuration

**Animation Options**

```dart
CreativeUIButtonOptions(
  animationOptions: CreativeUIButtonAnimationOptions(
    animationOptions: {
      AnimationType.pulsing: AnimationOptions(
        duration: const Duration(milliseconds: 800),
        pause: const Duration(seconds: 1),
      ),
      AnimationType.floating: AnimationOptions(
        from: -5.0,
        to: 5.0,
        duration: const Duration(seconds: 2),
      ),
    },
  ),
);
```

**Sound & Haptics**

```dart
CreativeUIButtonOptions(
  soundOptions: const CreativeUIButtonSoundOptions(
    sfxPath: 'assets/click.mp3',
    enableSFX: true,
    disableVibration: false,
  ),
);
```

---

## 🧩 Example

A complete example app lives in `/example`.

Run it:

```bash
cd example
flutter run
```

---

## 🧠 Architecture Highlights

- No theme access in `initState` → safe in all build phases  
- Adaptive to `ThemeData` changes and dark mode  
- Ripple + hover + focus layers follow Material guidelines  
- Easily extendable for new variants or shapes  

---

## 🧪 Testing

Run widget tests:

```bash
flutter test
```

You’ll find test coverage for:
- `CreativeUIButton`
- `AsyncButton`
- `CreativeUIBackButton`

---

## 🧰 Requirements

| Platform | Minimum |
|-----------|----------|
| Flutter | 3.13+ |
| Dart | 3.2+ |

---

## 🧑‍💻 Author

**Ollie Ogunlade**  
Flutter & Node.js Engineer  
[GitHub](https://github.com/o-ctech) • [LinkedIn](https://linkedin.com/in/ollieogunlade)

---

## 📄 License

MIT © 2025 Ollie Ogunlade