import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider with ChangeNotifier {
  // A set to store the IDs of the favorite items. Using a set ensures uniqueness.
  final Set<String> _favoriteItems = {};
  List<String> favoriteSongs = [];

  // Getter to expose a copy of the favorite items to prevent external modification
  Set<String> get favoriteItems => Set.from(_favoriteItems);

  // Method to add an item to the favorites and synchronize with Firebase
  Future<void> addFavorite(String itemId) async {
    _favoriteItems.add(itemId);
    await addToFirebaseFavorites(itemId);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Method to remove an item from the favorites and synchronize with Firebase
  Future<void> removeFavorite(String itemId) async {
    _favoriteItems.remove(itemId);
    await removeFromFirebaseFavorites(itemId);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Method to check if an item is in the favorites
  bool isFavorite(String itemId) {
    return _favoriteItems.contains(itemId);
  }

  // Method to add a song to Firebase favorites
  Future<void> addToFirebaseFavorites(String songName) async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString('userId');

    if (userId == null) {
      print("Error: User ID not found in SharedPreferences");
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('favourite_songs').doc(userId);

      // Check if document exists (optional, based on your requirements)
      final snapshot = await docRef.get();
      List<String> existingFavorites = [];
      if (snapshot.exists) {
        existingFavorites =
            (snapshot.data()!['my_favourite'] as List<dynamic>).cast<String>();
      }

      // Add the new song name
      existingFavorites.add(songName);

      // Update or create the document with the updated list
      await docRef.set({
        'my_favourite': existingFavorites,
      }, SetOptions(merge: true)); // Ensures efficient updates
    } catch (e) {
      print("Error adding to favorites: $e");
    }
  }

  // Method to remove a song from Firebase favorites
  Future<void> removeFromFirebaseFavorites(String songName) async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString('userId');

    if (userId == null) {
      print("Error: User ID not found in SharedPreferences");
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('favourite_songs').doc(userId);

      // Retrieve existing favorites
      final snapshot = await docRef.get();
      List<String> existingFavorites = [];
      if (snapshot.exists) {
        existingFavorites =
            (snapshot.data()!['my_favourite'] as List<dynamic>).cast<String>();
      }

      // Remove the song name
      existingFavorites.remove(songName);

      // Update or delete the document based on remaining favorites
      if (existingFavorites.isNotEmpty) {
        // Update with the remaining favorites
        await docRef.set({
          'my_favourite': existingFavorites,
        }, SetOptions(merge: true));
      } else {
        // Delete the document if no more favorites
        await docRef.delete();
      }
    } catch (e) {
      print("Error removing from favorites: $e");
    }
  }

  Future<List<String>?> getFavoriteSongs() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString('userId');
    if (userId == null) {
      print("Error: User ID not found in SharedPreferences");
      return null;
    }
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('favourite_songs').doc(userId);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data.containsKey('my_favourite')) {
          // Correctly handle the casting of List<dynamic> to List<String>
          var dynamicList = data['my_favourite'] as List<dynamic>;
          favoriteSongs = dynamicList.map((item) => item.toString()).toList();
          _favoriteItems.addAll(favoriteSongs);

          notifyListeners(); // Notify listeners to rebuild the UI
          return favoriteSongs;
        }
      }
      return null; // Indicate no favorites found
    } catch (e) {
      print("Error getting favorite songs: $e");
      return null; // Indicate an error occurred
    }
  }
}
