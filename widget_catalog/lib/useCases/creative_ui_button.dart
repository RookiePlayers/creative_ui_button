import 'package:creative_ui_button/creative_ui_button.dart';
import 'package:widget_catalog/useCases/button_knobs.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'default', type: CreativeUIButton)
Widget useCaseCreativeUIButton(BuildContext context) {
  return Center(
    child: CreativeUIButton(
      options: ButtonKnobs.options(context),
    ),
  );
}
