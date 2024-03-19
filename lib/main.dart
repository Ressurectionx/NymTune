import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymtune/src/bloc/bussiness_logic/blocs/home_blocs.dart';
import 'package:nymtune/src/core/utils/app_routes.dart';
import 'src/bloc/data/usecases/fetch_song_usecase.dart';

void main() {
  runApp(const NymTune());
}

class NymTune extends StatelessWidget {
  const NymTune({super.key});

  @override
  Widget build(BuildContext context) {
    final SongRemoteUsecase songRepo = SongRemoteUsecase();
    final HomeBloc homeBloc = HomeBloc(songRepository: songRepo);

    return BlocProvider(
      create: (context) => homeBloc,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.dashboardRoute,
          routes: AppRoutes.routes,
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
          )),
    );
  }
}
