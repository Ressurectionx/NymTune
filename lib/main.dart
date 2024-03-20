import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nymtune/firebase_options.dart';
import 'package:nymtune/src/core/utils/app_routes.dart';
import 'package:nymtune/src/presentation/data/usecases/fetch_song_usecase.dart';
import 'package:nymtune/src/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // // SafetyNet for Android
  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   await FirebaseAppCheck.instance.activate();
  // }
  runApp(const NymTune());
}

class NymTune extends StatelessWidget {
  const NymTune({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (context) =>
              HomeProvider(songRemoteUsecase: SongRemoteUsecase()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.dashboardRoute,
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
