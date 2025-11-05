import 'package:flutter/widgets.dart';
import 'package:vibration/vibration.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class Vibrator {
  static vibrate({
    bool sound = false,
    String soundUrl = "assets/sfx/ding_wet.wav",
  }) async {
    try {
      // Check if the device can vibrate
      bool canVibrate = (await Vibration.hasVibrator());

      if (canVibrate && (await Vibration.hasAmplitudeControl())) {
        Vibration.vibrate(amplitude: 128);
      }
    } catch (e) {
      debugPrint('Error in vibrate: $e');
    }
  }

  static feedback() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.selection);
      }
    } catch (e) {
      debugPrint('Error in feedback: $e');
    }
  }

  static success() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.success);
      }
    } catch (e) {
      debugPrint('Error in success: $e');
    }
  }

  static warn() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.warning);
      }
    } catch (e) {
      debugPrint('Error in warn: $e');
    }
  }

  static error() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.error);
      }
    } catch (e) {
      debugPrint('Error in error: $e');
    }
  }

  static light() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.light);
      }
    } catch (e) {
      debugPrint('Error in light: $e');
    }
  }

  static medium() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.medium);
      }
    } catch (e) {
      debugPrint('Error in medium: $e');
    }
  }

  static heavy() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.heavy);
      }
    } catch (e) {
      debugPrint('Error in heavy: $e');
    }
  }

  static rigid() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.rigid);
      }
    } catch (e) {
      debugPrint('Error in rigid: $e');
    }
  }

  static soft() async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        Haptics.vibrate(HapticsType.soft);
      }
    } catch (e) {
      debugPrint('Error in soft: $e');
    }
  }

  static cancelVibration() {
    try {
      Vibration.cancel();
    } catch (e) {
      debugPrint('Error in cancelVibration: $e');
    }
  }

  static vibrateWithPauses({bool sound = true}) async {
    try {
      // Check if the device can vibrate
      bool canVibrate = (await Vibration.hasCustomVibrationsSupport());

      final List<int> pauses = [500, 1000, 500];
      // vibrate - sleep 0.5s - vibrate - sleep 1s - vibrate - sleep 0.5s - vibrate
      if (canVibrate) {
        Vibration.vibrate(pattern: pauses);
      }
    } catch (e) {
      debugPrint('Error in vibrateWithPauses: $e');
    }
  }
}
