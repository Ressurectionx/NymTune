import 'package:flutter/foundation.dart';

class FavoriteProvider with ChangeNotifier {
  // A set to store the IDs of the favorite items. Using a set ensures uniqueness.
  final Set<String> _favoriteItems = {};

  // Getter to expose a copy of the favorite items to prevent external modification
  Set<String> get favoriteItems => Set.from(_favoriteItems);

  // Method to add an item to the favorites
  void addFavorite(String itemId) {
    _favoriteItems.add(itemId);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Method to remove an item from the favorites
  void removeFavorite(String itemId) {
    _favoriteItems.remove(itemId);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Method to check if an item is in the favorites
  bool isFavorite(String itemId) {
    return _favoriteItems.contains(itemId);
  }
}
