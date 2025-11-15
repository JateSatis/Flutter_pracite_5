// lib/app_dependencies.dart
import 'package:flutter/material.dart';
import 'app_state_model.dart';

class DependenciesProvider extends InheritedWidget {
  final AppStateModel model;

  const DependenciesProvider({
    super.key,
    required this.model,
    required super.child,
  });

  static AppStateModel of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<DependenciesProvider>();
    if (provider == null) {
      throw Exception('DependenciesProvider не найден в дереве');
    }
    return provider.model;
  }

  @override
  bool updateShouldNotify(DependenciesProvider oldWidget) {
    return model != oldWidget.model;
  }
}