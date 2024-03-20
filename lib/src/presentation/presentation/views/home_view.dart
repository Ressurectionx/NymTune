import 'package:flutter/material.dart';
import 'package:nymtune/src/presentation/presentation/widgets/trending_now.dart';
import 'package:nymtune/src/presentation/providers/home_provider.dart';
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
  @override
  void initState() {
    super.initState();
    // Call fetchSongs() in initState to ensure it's called only once
    Provider.of<HomeProvider>(context, listen: false).fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Colors.black,
            title: Text("Your App Title"), // Replace with your app title
            floating: true,
            snap: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Your widget content here
                Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      // Display loading indicator while fetching songs
                      return const Center(
                        child: const CircularProgressIndicator(),
                      );
                    } else if (provider.hasError) {
                      // Display error message if fetching songs failed
                      return Center(
                        child: Text('Error: ${provider.errorMessage}'),
                      );
                    } else {
                      // If data is loaded successfully, build the UI
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            const HWSearchBar(),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "top picks for you",
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.subHeader.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Assuming you have a widget to display top picks here
                            TopPicks(),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "trending now",
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.subHeader.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Assuming you have a widget to display trending songs here
                            TrendingNow(),
                          ],
                        ),
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
