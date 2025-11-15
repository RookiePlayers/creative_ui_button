// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widget_catalog/useCases/async_button.dart'
    as _widget_catalog_useCases_async_button;
import 'package:widget_catalog/useCases/creative_ui_back_button.dart'
    as _widget_catalog_useCases_creative_ui_back_button;
import 'package:widget_catalog/useCases/creative_ui_button.dart'
    as _widget_catalog_useCases_creative_ui_button;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'components',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'buttons',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AsyncButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'default',
                builder:
                    _widget_catalog_useCases_async_button.useCaseAsyncButton,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'CreativeUIBackButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'default',
                builder: _widget_catalog_useCases_creative_ui_back_button
                    .useCaseCreativeUIBackButton,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'CreativeUIButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'default',
                builder: _widget_catalog_useCases_creative_ui_button
                    .useCaseCreativeUIButton,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
