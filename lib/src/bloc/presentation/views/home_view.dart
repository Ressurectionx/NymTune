// home_screen.dart

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymtune/src/bloc/presentation/widgets/hw_header.dart';
import 'package:nymtune/src/bloc/presentation/widgets/trending_now.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../bussiness_logic/blocs/home_blocs.dart';
import '../../bussiness_logic/states/home_state.dart';
import '../widgets/hw_search_bar.dart';
import '../widgets/top_picks.dart';
import 'setting.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const HWHeader(),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // if (state is HomeInitial) {
          //   // Initial state, you might want to show loading indicator or similar
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // } else if (state is SongsLoaded) {
          //   // State when songs are loaded, show the list of songs
          //   return ListView.builder(
          //     itemCount: state.songs.length,
          //     itemBuilder: (context, index) {
          //       final song = state.songs[index];
          //       // Build UI for each song item
          //       return ListTile(
          //         title: Text(song.title),
          //         // Add functionality to favorite a song
          //         // For example: onTap: () => BlocProvider.of<HomeBloc>(context).add(FavoriteSong(song.id)),
          //       );
          //     },
          //   );
          // } else if (state is HomeError) {
          //   // State when there's an error loading songs
          //   return Center(
          //     child: Text(state.message),
          //   );
          // }
          // // Other states can be handled similarly if needed
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                const HWSearchBar(),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "top picks for you",
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subHeader.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TopPicks(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "trending now",
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subHeader.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TrendingNow(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [HomeView(), Setting()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(),
    );
  }
}
