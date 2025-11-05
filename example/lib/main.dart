import 'dart:async';
import 'package:flutter/material.dart';

// Prefer importing from your public barrel file.
// Ensure lib/creative_ui_button.dart exports the widgets below.
import 'package:creative_ui_button/creative_ui_button.dart';
// If you haven't exposed barrels yet, temporarily import directly:
// import 'package:creative_ui_button/src/components/buttons/game_button.dart';
// import 'package:creative_ui_button/src/components/wrappers/async_button.dart';
// import 'package:creative_ui_button/src/components/wrappers/creative_ui_back_button.dart';
// import 'package:creative_ui_button/src/models/button_options.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creative UI Button – Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0060F1)),
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const HomePage(),
        '/details': (_) => const DetailsPage(),
      },
      initialRoute: '/',
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _fakeNetworkCall() async {
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons Showcase'),
        // No back button here; stack root shows auto-hide behavior if you try it
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text('Contained', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            CreativeUIButton(
              options: CreativeUIButtonOptions(
                variant: ButtonVariant.contained,
                style: CreativeUIButtonStyle(
                  backgroundColor: cs.primary,
                  textStyle: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w700),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  borderRadius: 14,
                ),
                icon: const Icon(Icons.flash_on, color: Colors.white),
                labelText: 'Contained',
                onPressed: () => _snack(context, 'Contained tapped'),
              ),
            ),
            const SizedBox(height: 24),
        
            Text('Outlined', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            CreativeUIButton(
              options: CreativeUIButtonOptions(
                variant: ButtonVariant.outlined,
                style: CreativeUIButtonStyle(
                  borderColor: cs.primary,
                  textStyle: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  borderRadius: 14,
                ),
                icon: Icon(Icons.border_all, color: cs.primary),
                labelText: 'Outlined',
                onPressed: () => _snack(context, 'Outlined tapped'),
              ),
            ),
            const SizedBox(height: 24),
        
            Text('Text', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            CreativeUIButton(
              options: CreativeUIButtonOptions(
                variant: ButtonVariant.text,
                style: CreativeUIButtonStyle(
                  textStyle: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                ),
                icon: Icon(Icons.text_fields, color: cs.primary),
                labelText: 'Text Button',
                onPressed: () => _snack(context, 'Text tapped'),
              ),
            ),
            const SizedBox(height: 24),
        
            Text('Animated', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            CreativeUIButton(
              options: CreativeUIButtonOptions(
                variant: ButtonVariant.animated,
                style: CreativeUIButtonStyle(
                  backgroundColor: cs.primary,
                  textStyle: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w700),
                  size: const Size(160, 48),
                  borderRadius: 16,
                ),
                labelText: 'Animated',
                onPressed: () => _snack(context, 'Animated tapped'),
              ),
            ),
            const SizedBox(height: 24),
        
            Text('AsyncButton (awaits 2s)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            AsyncButton(
              options: CreativeUIButtonOptions(
                variant: ButtonVariant.contained,
                style: CreativeUIButtonStyle(
                  backgroundColor: cs.secondary,
                  textStyle: TextStyle(color: cs.onSecondary, fontWeight: FontWeight.w700),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  borderRadius: 14,
                ),
                labelText: 'Submit',
              ),
              onAsyncSubmit: () async {
                await _fakeNetworkCall();
                if (context.mounted) _snack(context, 'Submitted!');
              },
              onError: (e, st) => debugPrint('Async error: $e'),
            ),
            const SizedBox(height: 24),
        
            Text('Animated With Effects',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            CreativeUIButton(
              options: CreativeUIButtonOptions(
                variant: ButtonVariant.animated,
                animatedButtonConfig: AnimatedButtonConfig(
                borderRadius: 20,
                shimmerHighlight: Colors.red,
                sweepShimmerConfig: SweepShimmerConfig(
                  highlightColor: Color(0xFF6dc6ff),
                  pause: Duration(milliseconds: 1500),
                  duration: Duration(milliseconds: 2000),
                ),
                effects: [
                  ButtonEffect.sweepShimmer,
                  ButtonEffect.shimmer,
                  ButtonEffect.glow,
                ]),
                child: Text(
                  "Animated With Effects",
                  style: TextStyle(fontSize: 24),
                ),
                style: CreativeUIButtonStyle(
                  size:  Size(150, 50),
                  backgroundColor: Color(0xFF6dc6ff),
                  textStyle: TextStyle(color: cs.onTertiary, fontWeight: FontWeight.w700),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  borderRadius: 20,
                ),
                labelText: 'Open Details',
                icon: const Icon(Icons.open_in_new, color: Colors.white),
                onPressed: () => Navigator.of(context).pushNamed('/details'),
              ),
            ),
            const SizedBox(height: 64),
        
            Text('Navigate to Details (Back Button demo)',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            CreativeUIBackButton(
              options: CreativeUIButtonOptions(
                variant: ButtonVariant.contained,
                style: CreativeUIButtonStyle(
                  backgroundColor: cs.tertiary,
                  textStyle: TextStyle(color: cs.onTertiary, fontWeight: FontWeight.w700),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  borderRadius: 14,
                ),
                labelText: 'Open Details',
                icon: const Icon(Icons.open_in_new, color: Colors.white),
                onPressed: () => Navigator.of(context).pushNamed('/details'),
              ),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        // Back button that pops if possible; if not, goes home
        leading: CreativeUIBackButton(
          fallbackRoute: '/',
          // Custom label/style optional
          options: CreativeUIButtonOptions(
            variant: ButtonVariant.text,
            style: CreativeUIButtonStyle(
              textStyle: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: CreativeUIButton(
          options: CreativeUIButtonOptions(
            variant: ButtonVariant.outlined,
            style: CreativeUIButtonStyle(
              borderColor: cs.primary,
              textStyle: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              borderRadius: 14,
            ),
            icon: Icon(Icons.home, color: cs.primary),
            labelText: 'Go Home (clear stack)',
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false),
          ),
        ),
      ),
    );
  }
}