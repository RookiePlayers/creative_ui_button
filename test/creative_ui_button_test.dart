import 'package:creative_ui_button/src/components/buttons/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Update these imports to your actual paths:
import 'package:creative_ui_button/src/models/button_options.dart';

Widget _appWithRoutes({required Widget home}) {
  return MaterialApp(
    routes: {
      '/': (_) => home,
      '/home': (_) => const _HomePage(),
      '/second': (_) => const _SecondPage(),
    },
    initialRoute: '/',
  );
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed('/second'),
          child: const Text('Go Second'),
        ),
      ),
    );
  }
}

class _SecondPage extends StatelessWidget {
  const _SecondPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second'),
        leading: const CreativeUIBackButton(), // uses default (outlined)
      ),
      body: const Center(child: Text('Second Body')),
    );
  }
}

void main() {
  testWidgets('Hides itself on root when no fallback', (tester) async {
    final rootWithBack = Scaffold(
      appBar: AppBar(
        title: const Text('Root'),
        leading: const CreativeUIBackButton(autoHide: true),
      ),
      body: const SizedBox(),
    );

    await tester.pumpWidget(_appWithRoutes(home: rootWithBack));
    await tester.pumpAndSettle();

    // Back button should be hidden on root (no canPop, no fallback)
    expect(find.byType(CreativeUIBackButton), findsOneWidget); // exists in tree
    // But because autoHide is true and no pop/fallback, it should render as shrink:
    // The Ink/child won't be present. Look for the default "Back" label not found.
    expect(find.text('Back'), findsNothing);
  });

  testWidgets('Pops when stack can pop', (tester) async {
    await tester.pumpWidget(_appWithRoutes(home: const _HomePage()));
    await tester.pumpAndSettle();

    // Go to second
    await tester.tap(find.text('Go Second'));
    await tester.pumpAndSettle();

    // We are on second page, back button visible (AppBar leading)
    expect(find.text('Second'), findsOneWidget);
    expect(find.byType(CreativeUIBackButton), findsOneWidget);

    // Tap back
    // Find the tappable leading by semantics "Back" label text inside our default child
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Should be back on Home
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Second'), findsNothing);
  });

  testWidgets('Uses fallback when stack cannot pop', (tester) async {
    // Root page shows a back button with a fallback route
    final root = Scaffold(
      appBar: AppBar(
        title: const Text('Root'),
        leading: const CreativeUIBackButton(
          fallbackRoute: '/home',
          autoHide: false, // show the button even if stack can't pop
        ),
      ),
      body: const SizedBox(),
    );

    await tester.pumpWidget(_appWithRoutes(home: root));
    await tester.pumpAndSettle();

    // We should see the back button (label "Back")
    expect(find.text('Back'), findsOneWidget);

    // Tap back; since cannot pop, should push fallback '/home' and clear stack
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Now on /home
    expect(find.text('Home'), findsOneWidget);
    // Stack cleared; pushing "Go Second" works as normal
    await tester.tap(find.text('Go Second'));
    await tester.pumpAndSettle();
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('Custom options render & onBack override is used', (
    tester,
  ) async {
    bool called = false;

    final root = Scaffold(
      appBar: AppBar(
        title: const Text('Root'),
        leading: CreativeUIBackButton(
          onBack: () => called = true,
          label: 'Custom Back',
          options: const CreativeUIButtonOptions(
            // Verify variant customization passes through
            variant: ButtonVariant.text,
          ),
        ),
      ),
    );

    await tester.pumpWidget(_appWithRoutes(home: root));
    await tester.pumpAndSettle();

    expect(find.text('Custom Back'), findsOneWidget);
    await tester.tap(find.text('Custom Back'));
    await tester.pump();

    expect(called, isTrue);
  });
}
