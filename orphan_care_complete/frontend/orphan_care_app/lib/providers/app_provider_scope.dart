import 'package:flutter/widgets.dart';

import 'app_provider.dart';

class AppProviderScope extends InheritedNotifier<AppProvider> {
  const AppProviderScope({
    super.key,
    required AppProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static AppProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppProviderScope>();
    assert(scope != null, 'AppProviderScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
