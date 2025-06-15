import 'package:flutter/foundation.dart';

class CounterNotifier with ChangeNotifier, DiagnosticableTreeMixin {
  CounterNotifier._();

  static final CounterNotifier _instance = CounterNotifier._();

  factory CounterNotifier() => _instance;

  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}
