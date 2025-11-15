import 'package:flutter/widgets.dart';
import 'package:widget_catalog/useCases/button_knobs.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:creative_ui_button/creative_ui_button.dart';

@widgetbook.UseCase(name: 'default', type: AsyncButton)
Widget useCaseAsyncButton(BuildContext context) {
  return Center(
    child: AsyncButton(
      options: ButtonKnobs.options(context),
      loading: context.knobs.boolean(label: 'Loading'),
      onAsync: () {},
      onAsyncSubmit: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      onSuccess: () {},
      onError: (_, __) {},
    ),
  );
}
