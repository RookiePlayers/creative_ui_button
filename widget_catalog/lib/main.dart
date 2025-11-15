import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';

void main() {
  runApp(const WidgetBookCatalog());
}

@widgetbook.App()
class WidgetBookCatalog extends StatelessWidget {
  const WidgetBookCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(directories: [
        
      ],
    );
  }
}
