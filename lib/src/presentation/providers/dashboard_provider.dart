import 'package:flutter/foundation.dart';

class DashboardProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners(); // Notify all listeners to rebuild.
    }
  }
}
