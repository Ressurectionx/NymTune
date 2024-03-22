import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/presentation/presentation/widgets/trending_now.dart';
import 'package:nymtune/src/presentation/providers/song_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/hw_header.dart';
import '../widgets/hw_search_bar.dart';
import '../widgets/top_picks.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  SongProvider? provider;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onVerticalScroll);
    _horizontalScrollController.addListener(_onHorizontalScroll);
    provider = Provider.of<SongProvider>(context, listen: false);
    provider?.fetchSongs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Timer? _debounce;

  void _onVerticalScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (provider!.hasMore && !provider!.isLoading) {
          provider!.fetchSongs();
        }
      }
    });
  }

  void _onHorizontalScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      if (_horizontalScrollController.position.pixels >=
          _horizontalScrollController.position.maxScrollExtent - 500) {
        if (provider!.hasMore && !provider!.isLoading) {
          provider!.fetchSongs();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController, // Attach scroll controller

        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Colors.black,
            title: HWHeader(), // Replace with your app title
            floating: true,
            snap: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Your widget content here
                Consumer<SongProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      // Display loading indicator while fetching songs
                      return
                          // Display loading indicator (Lottie animation) at center
                          SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Lottie.asset(
                                "assets/images/music.json", // Replace with your actual Lottie file
                                width: 100, // Adjust width and height as needed
                                height: 100,
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      );
                    } else if (provider.hasError) {
                      // Display error message if fetching songs failed
                      return Center(
                        child: Text('Error: ${provider.errorMessage}'),
                      );
                    } else {
                      // If data is loaded successfully, build the UI
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const HWSearchBar(),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              "top picks for you",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subHeader.copyWith(
                                  color: AppColors.greenYellow(),
                                  fontFamily: "OldTurkic",
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Assuming you have a widget to display top picks here
                          TopPicks(
                            horizontalScrollController:
                                _horizontalScrollController,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              "trending now",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subHeader.copyWith(
                                  color: AppColors.greenYellow(),
                                  fontFamily: "OldTurkic",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Assuming you have a widget to display trending songs here
                          const TrendingNow(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
