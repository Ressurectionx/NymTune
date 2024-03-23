import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nymtune/firebase_options.dart';
import 'package:nymtune/src/core/utils/app_routes.dart';
import 'package:nymtune/src/presentation/data/usecases/fetch_song_usecase.dart';
import 'package:nymtune/src/presentation/data/usecases/search_usecase.dart';
import 'package:nymtune/src/presentation/providers/dashboard_provider.dart';
import 'package:nymtune/src/presentation/providers/favourite_provider.dart';
import 'package:nymtune/src/presentation/providers/search_song_provider.dart';
import 'package:nymtune/src/presentation/providers/signup_providers.dart';
import 'package:provider/provider.dart';

import 'src/presentation/data/repositories/search_repo.dart';
import 'src/presentation/providers/song_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NymTune());
}

class NymTune extends StatelessWidget {
  const NymTune({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SongProvider>(
          create: (context) =>
              SongProvider(songRemoteUsecase: SongRemoteUsecase()),
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (context) => DashboardProvider(),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (context) {
            final repository = SearchRepository(); // Assuming a global instance
            return SearchProvider(SearchSongsUseCase(repository));
          },
        ),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute:
            currentUser == null ? AppRoutes.signUp : AppRoutes.dashboard,
        routes: AppRoutes.routes,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
        ),
      ),
    );
  }
}

// class FirebaseFirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   var jsonString = [
//     {
//       "album": "They Don't Care About Us",
//       "artist": "Michael Jackson",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url":
//           "https://i.ytimg.com/vi/Bhca6QJSRW8/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AH-CYAC0AWKAgwIABABGBkgYihyMA8=&rs=AOn4CLDWQEEuOeK1L8RP0ztNnFPywBkCuA",
//       "title": "They Don't Care About Us"
//     },
//     {
//       "album": "Kannamma",
//       "artist": "Ben Human",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url":
//           "https://i.scdn.co/image/ab67616d0000b273340aa4c5bbc926386db7c2bb",
//       "title": "Kannamma"
//     },
//     {
//       "album": "Singara Siriye",
//       "artist": "Vijay Prakash, Ananya Bhat",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url":
//           "https://c.saavncdn.com/999/Singara-Siriye-From-Kantara-Kannada-2022-20230903200109-500x500.jpg0",
//       "title": "Singara Siriye"
//     },
//     {
//       "album": "Sojugada Soojumallige",
//       "artist": "Chaithra J Achar, Midhun Mukundan",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url":
//           "https://talkingtalkies.files.wordpress.com/2021/11/poster.jpg",
//       "title": "Sojugada Soojumallige"
//     },
//     {
//       "album": "Sairat Jhala Ji",
//       "artist": "Chinmayi, Ajay Gogavale",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url": "https://c.saavncdn.com/998/Sairat-Marathi-2016-500x500.jpg",
//       "title": "Sairat Jhala Ji"
//     },
//     {
//       "album": "With You",
//       "artist": "AP Dhillon",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url":
//           "https://www.bollywoodhungama.com/wp-content/uploads/2023/08/Banita-Sandhu-and-AP-Dhillon-spice-up-things-up-as-they-formally-announce-their-romance-on-Instagram-3.jpg",
//       "title": "With You"
//     },
//     {
//       "album": "Dil Nu",
//       "artist": "AP Dhillon",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url":
//           "https://c.saavncdn.com/070/Two-Hearts-Never-Break-The-Same-Punjabi-2022-20230205155200-500x500.jpg",
//       "title": "Dil Nu"
//     },
//     {
//       "album": "Maharani",
//       "artist": "Karun, Lambo Drive",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url":
//           "https://i.ytimg.com/vi/N1s-GN1SWqY/sddefault.jpg?v=65913470",
//       "title": "Maharani"
//     },
//     {
//       "album": "Yimmy Yimmy",
//       "artist": "Shreya Ghoshal, Tayc",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url":
//           "https://c.saavncdn.com/300/Yimmy-Yimmy-Hindi-2024-20240313180215-500x500.jpg",
//       "title": "Yimmy Yimmy"
//     },
//     {
//       "album": "Maiya maiya",
//       "artist": "Nithyashree",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url": "https://i.ytimg.com/vi/eifDPEgAFCs/maxresdefault.jpg",
//       "title": "Maiya maiya"
//     },
//     {
//       "album": "Yathavkash",
//       "artist": "Rocksun",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url": "https://i.ytimg.com/vi/LcKFMPBwU3k/hqdefault.jpg",
//       "title": "Yathavkash"
//     },
//     {
//       "album": "Sambar",
//       "artist": "ThirumaLi, Fejo & Dabzee",
//       "audio_url": "gs://nymtune.appspot.com/unaku_thaan_chithha.mp3",
//       "duration": "3.45",
//       "genre": "Rhythm and blues",
//       "image_url": "https://i.ytimg.com/vi/r6egHcGiUjs/mqdefault.jpg",
//       "title": "Sambar"
//     }
//   ];

//   Future<void> uploadSongsFromJson() async {
//     // Parse the JSON string into a list of maps
//     List<Map<String, dynamic>> songsData = jsonString;

//     for (var songData in songsData) {
//       // Generate a unique document ID startin1g from "02"
//       String docId = '03';
//       CollectionReference collection = _firestore
//           .collection('songs')
//           .doc("top_picks")
//           .collection("collection");
//       bool exists = false;
//       do {
//         DocumentSnapshot snapshot = await collection.doc(docId).get();
//         exists = snapshot.exists;
//         if (exists) {
//           int id = int.parse(docId) +
//               1; // This will parse "03" to 3, then increment to 4
//           docId = id.toString().padLeft(2,
//               '0'); // Converts back to string, ensuring it has at least 2 digits, e.g., "04"
//         }
//       } while (exists);

//       // Upload each song data with the generated unique ID
//       await collection.doc(docId).set(songData);
//     }

//     print('Songs uploaded successfully!');
//   }
// }
