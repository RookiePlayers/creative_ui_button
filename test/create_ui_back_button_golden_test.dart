// test/creative_ui_back_button_golden_test.dart
import 'package:creative_ui_button/src/components/buttons/back_button.dart';
import 'package:creative_ui_button/src/models/button_options.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// import your back button + options here

void main() {
  testGoldens('Back button states', (tester) async {
    final widget = MaterialApp(
      home: Material(
        child: Row(
          children: const [
            CreativeUIBackButton(),
            SizedBox(width: 16),
            CreativeUIBackButton(
              label: 'Back (text)',
              options: CreativeUIButtonOptions(variant: ButtonVariant.text),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidgetBuilder(widget);
    await screenMatchesGolden(tester, 'creative_ui_back_button_states');
  });
}