// home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bussiness_logic/blocs/home_blocs.dart';
import '../../bussiness_logic/states/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            // Initial state, you might want to show loading indicator or similar
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SongsLoaded) {
            // State when songs are loaded, show the list of songs
            return ListView.builder(
              itemCount: state.songs.length,
              itemBuilder: (context, index) {
                final song = state.songs[index];
                // Build UI for each song item
                return ListTile(
                  title: Text(song.title),
                  // Add functionality to favorite a song
                  // For example: onTap: () => BlocProvider.of<HomeBloc>(context).add(FavoriteSong(song.id)),
                );
              },
            );
          } else if (state is HomeError) {
            // State when there's an error loading songs
            return Center(
              child: Text(state.message),
            );
          }
          // Other states can be handled similarly if needed
          return Container();
        },
      ),
    );
  }
}
