import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymtune/src/bloc/bussiness_logic/blocs/home_blocs.dart';
import 'package:nymtune/src/bloc/presentation/views/home_view.dart';

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

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) => homeBloc,
          child: const DashboardScreen(),
        ),
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
        ));
  }
}
