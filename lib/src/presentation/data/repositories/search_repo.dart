import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song_model.dart';

class SearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Song>> searchSongs(String searchTerm) async {
    final querySnapshot = await _firestore
        .collection('songs')
        .doc('top_picks')
        .collection('collection')
        // Use title for comparison (case-insensitive)
        .where('title_for_search',
            isGreaterThanOrEqualTo: searchTerm.toLowerCase())
        .where('title_for_search',
            isLessThanOrEqualTo: '${searchTerm.toLowerCase()}\uf8ff')
        .get();

    // Create Song objects from fetched data
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return Song.fromJson(data);
    }).toList();
  }
}

// Future<void> updateTitleForSearchField() async {
//   final collection = FirebaseFirestore.instance
//       .collection('songs')
//       .doc('top_picks')
//       .collection('collection');

//   final querySnapshot = await collection.get();

//   for (var doc in querySnapshot.docs) {
//     final title = doc.data()['title'] as String? ?? '';
//     // Remove the 'title_lowercase' field
//     await doc.reference.update({
//       'title_lowercase': FieldValue.delete(),
//       // Add the 'title_for_search' field with the lowercase title
//       'title_for_search': title.toLowerCase(),
//     });
//   }

//   print('title_for_search field updated successfully!');
// }
