import 'package:creative_ui_button/creative_ui_button.dart';
import 'package:widget_catalog/useCases/button_knobs.dart';

import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'default', type: CreativeUIBackButton)
Widget useCaseCreativeUIBackButton(BuildContext context) {
  return Center(
    child: CreativeUIBackButton(
    
      options: ButtonKnobs.options(context),
      onBack: () {},
      icon: const SizedBox.shrink(),
      label: context.knobs.stringOrNull(label: 'Label'),
      autoHide: context.knobs.boolean(label: 'Auto hide'),
      fallbackRoute: context.knobs.stringOrNull(label: 'Fallback route'),
    ),
  );
}
