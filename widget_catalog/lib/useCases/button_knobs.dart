import 'package:flutter/material.dart';
import 'package:creative_ui_button/creative_ui_button.dart';
import 'package:widgetbook/widgetbook.dart';

class ButtonKnobs {
  static CreativeUIButtonOptions? options(BuildContext context) =>
      context.knobs.objectOrNull.segmented<CreativeUIButtonOptions>(
        label: 'Options',
        options: [
          CreativeUIButtonOptions(
            labelText: context.knobs.stringOrNull(label: 'Label', initialValue: 'Button'),
            disabled: context.knobs.boolean(label: 'Disabled'),
            variant: context.knobs.object.dropdown<ButtonVariant>(
              label: 'Variant',
              options: ButtonVariant.values,
            ),
            onPressed: () {
              showBottomSheet(context: context, builder: (c) {
                return Container(
                  height: 200,
                  color: Colors.white,
                  child: const Center(
                    child: Text('Button pressed!'),
                  ),
                );
              });
            },
            style: CreativeUIButtonStyle(
              size: Size(
                context.knobs.double.slider(label: 'Width', initialValue: 200, min: 50, max: 400),
                context.knobs.double.slider(label: 'Height', initialValue: 50, min: 20, max: 200),
              ),
              shape: context.knobs.object.dropdown<BoxShape>(
                label: 'Shape',
                options: [BoxShape.rectangle, BoxShape.circle],
              ),
              textStyle: TextStyle(
                fontSize: context.knobs.double.slider(
                  label: 'Font size',
                  initialValue: 16,
                  min: 8,
                  max: 32,
                ),
              ),
              borderColor: context.knobs.color(label: 'Border color'),
              borderRadius: context.knobs.double.slider(
                label: 'Border radius',
                initialValue: 8,
                min: 0,
                max: 32,
              ),
              backgroundColor: context.knobs.color(label: 'Background color'),
              borderWidth: context.knobs.double.slider(
                label: 'Border width',
                initialValue: 2,
                min: 0,
                max: 10,
              ),
              boxShadow: context.knobs.object.dropdown<BoxShadow>(
                label: 'Box shadow',
                options: [
                  BoxShadow(
                    color: context.knobs.color(label: 'Shadow color'),
                    blurRadius: context.knobs.double.slider(
                      label: 'Shadow blur radius',
                      initialValue: 4,
                      min: 0,
                      max: 20,
                    ),
                    offset: Offset(
                      context.knobs.double.slider(
                        label: 'Shadow offset X',
                        initialValue: 0,
                        min: -20,
                        max: 20,
                      ),
                      context.knobs.double.slider(
                        label: 'Shadow offset Y',
                        initialValue: 2,
                        min: -20,
                        max: 20,
                      ),
                    ),
                  ),
                ],
              ),
              applyShadow: context.knobs.boolean(label: 'Apply shadow'),
              disabledColor: context.knobs.color(label: 'Disabled color'),
              disabledOpacity: context.knobs.double.slider(
                label: 'Disabled opacity',
                initialValue: 0.5,
                min: 0,
                max: 1,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: context.knobs.double.slider(
                  label: 'Horizontal padding',
                  initialValue: 16,
                  min: 0,
                  max: 64,
                ),
                vertical: context.knobs.double.slider(
                  label: 'Vertical padding',
                  initialValue: 12,
                  min: 0,
                  max: 64,
                ),
              ),
              gradient: context.knobs.object.dropdown(
                label: 'Gradient',
                options: [
                  LinearGradient(
                    colors: [
                      context.knobs.color(label: 'Gradient start color'),
                      context.knobs.color(label: 'Gradient end color'),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  RadialGradient(
                    colors: [
                      context.knobs.color(
                        label: 'Radial gradient center color',
                      ),
                      context.knobs.color(label: 'Radial gradient edge color'),
                    ],
                    center: Alignment.center,
                    radius: 0.5,
                  ),
                  SweepGradient(
                    colors: [
                      context.knobs.color(label: 'Sweep gradient start color'),
                      context.knobs.color(label: 'Sweep gradient end color'),
                    ],
                    center: Alignment.center,
                  ),
                ],
              ),
              useGradient: context.knobs.boolean(label: 'Use gradient'),
            ),
            animatedButtonConfig: AnimatedButtonConfig(
              effects:
                  context.knobs.iterableOrNull
                      .segmented(
                        label: "Button Animations",
                        options: ButtonEffect.values,
                      )
                      ?.map((e) => e)
                      .toList() ??
                  [],
            ),
            soundOptions: CreativeUIButtonSoundOptions(),
          ),
        ],
      );
}
