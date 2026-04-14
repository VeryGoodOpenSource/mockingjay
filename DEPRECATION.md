# Mockingjay — Deprecation Notice & Migration Guide

> **This package is deprecated and is no longer actively maintained.**
> The repository remains public and available for the community to fork.

---

## Why is Mockingjay being deprecated?

Mockingjay provides mock classes for testing Flutter's **Navigator 1.0** (imperative) APIs.
The Flutter ecosystem has broadly shifted toward **Navigator 2.0** — the declarative navigation API —
and packages like [`go_router`](https://pub.dev/packages/go_router) have become the de facto standard
for navigation in modern Flutter applications.

Given this shift, maintaining Mockingjay no longer aligns with the current direction of the Flutter
community. Rather than let it languish with infrequent updates, we are making the deprecation official
so users can plan accordingly.

The package will remain available on [pub.dev](https://pub.dev/packages/mockingjay) and the source
code will stay public and available to fork. If there is enough community interest, anyone is welcome to create
and maintain a community edition.

---

## What should I do if I'm using Mockingjay?

You have two paths depending on how your app handles navigation:

### Path 1 — Migrate to Navigator 2.0 (recommended)

If you are building a new app or are willing to update your navigation layer, migrating to
Navigator 2.0 is the recommended long-term path.

1. **Adopt `go_router`** (or another Navigator 2.0-compatible package) for your app's routing.
   See the [go_router documentation](https://pub.dev/packages/go_router) to get started.

2. **Update your tests.** With `go_router`, navigation is driven by a `GoRouter` instance.
   In tests, you can provide a mock router with a test-specific configuration and inject it as a `Provider` so you can access it through `BuildContext`:

   ```dart
   final router = GoRouter(
     initialLocation: '/',
     routes: [
       GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
       GoRoute(path: '/detail', builder: (_, __) => const DetailScreen()),
     ],
   );

   testWidgets('navigates to detail', (tester) async {
     await tester.pumpWidget(MaterialApp.router(routerConfig: router));
     // Interact and assert normally
   });
   ```

3. **Remove the `mockingjay` dependency** from your `pubspec.yaml` once all usages have been replaced.

---

### Path 2 — Continue using Navigator 1.0 (no migration)

Navigator 1.0 is still part of Flutter and is not going away. If your project intentionally uses
the imperative API and you rely on Mockingjay, you have two options:

- **Fork the repository** and maintain your own copy. The source code is fully public under its
  existing license.
- **Use `NavigatorObserver` and manual test doubles** as a lightweight alternative, which requires
  no third-party package.

---

## Resources

- [go_router on pub.dev](https://pub.dev/packages/go_router)
- [Flutter Navigation & Routing docs](https://docs.flutter.dev/ui/navigation)
- [Navigator 2.0 overview](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade)

---

Thank you to everyone who used and contributed to Mockingjay over the years.
